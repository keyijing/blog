# frozen_string_literal: true

require "cgi"
require "jekyll/converters/markdown/kramdown_parser"
require "nokogiri"

module Jekyll
  module Utils
    class << self
      def has_yaml_header?(file)
        line = File.open(file, "rb", &:readline).delete_prefix("\xEF\xBB\xBF".b)
        !!(line =~ /\A---\s*\r?\n/)
      rescue EOFError
        false
      end
    end
  end

  module Converters
    class Markdown
      class MathProtectedKramdown
        ADMONITIONS = {
          "blue" => "circle-info",
          "green" => "circle-check",
          "teal" => "circle-info",
          "purple" => "star",
          "yellow" => "lightbulb",
          "amber" => "triangle-exclamation",
          "orange" => "triangle-exclamation",
          "red" => "circle-xmark",
        }.freeze

        ADMONITION_RE = /\A\s*\[!(#{ADMONITIONS.keys.join("|")})(?:(?:\||\s+)([A-Za-z][A-Za-z,\s-]*))?\]([+-])?\s*(.*?)\s*\z/im.freeze

        FENCE_RE = /\A(?: {0,3}> ?)* {0,3}(`{3,}|~{3,})/.freeze
        PLACEHOLDER_PREFIX = "MATHPROTECTED"
        PLACEHOLDER_SUFFIX = "END"

        def initialize(config)
          @parser = KramdownParser.new(config)
        end

        def convert(content)
          protected_content, math_spans = protect_math(content.to_s)
          html = @parser.convert(protected_content)
          html = convert_alerts(html)
          restore_math(html, math_spans)
        end

        private

        def protect_math(content)
          math_spans = []
          output = +""
          index = 0
          fence = nil

          while index < content.length
            if line_start?(content, index)
              line, next_index = current_line(content, index)

              if fence
                output << line
                fence = nil if closing_fence?(line, fence)
                index = next_index
                next
              end

              if (match = line.match(FENCE_RE))
                fence = [match[1][0], match[1].length]
                output << line
                index = next_index
                next
              end
            end

            if content[index] == "`"
              code_end = find_code_span_end(content, index)
              if code_end
                output << content[index...code_end]
                index = code_end
              else
                output << content[index]
                index += 1
              end
              next
            end

            math = read_math(content, index)
            if math
              token = "#{PLACEHOLDER_PREFIX}#{math_spans.length}#{PLACEHOLDER_SUFFIX}"
              math_spans << { "token" => token, "display" => math["display"], "body" => math["body"] }
              output << token
              index = math["end"]
              next
            end

            output << content[index]
            index += 1
          end

          [output, math_spans]
        end

        def line_start?(content, index)
          index.zero? || content[index - 1] == "\n"
        end

        def current_line(content, index)
          newline = content.index("\n", index)
          line_end = newline ? newline + 1 : content.length
          [content[index...line_end], line_end]
        end

        def closing_fence?(line, fence)
          char, length = fence
          line.match?(/\A(?: {0,3}> ?)* {0,3}#{Regexp.escape(char)}{#{length},}\s*\z/)
        end

        def find_code_span_end(content, index)
          opener = content[index..].match(/\A`+/)[0]
          close = content.index(opener, index + opener.length)
          close && close + opener.length
        end

        def read_math(content, index)
          if content[index, 2] == "$$" && valid_block_dollar_opener?(content, index)
            return read_delimited_math(content, index, "$$", "$$", true)
          end

          if content[index, 2] == "\\["
            return read_delimited_math(content, index, "\\[", "\\]", true)
          end

          if content[index, 2] == "\\("
            return read_delimited_math(content, index, "\\(", "\\)", false)
          end

          if content[index] == "$" && valid_inline_dollar_opener?(content, index)
            return read_delimited_math(content, index, "$", "$", false)
          end

          nil
        end

        def read_delimited_math(content, index, left, right, display)
          body_start = index + left.length
          body_end = find_math_end(content, body_start, right)
          return nil unless body_end
          return nil if right == "$" && !valid_inline_dollar_closer?(content, body_end)

          {
            "body" => content[body_start...body_end],
            "display" => display,
            "end" => body_end + right.length,
          }
        end

        def find_math_end(content, index, delimiter)
          brace_depth = 0

          while index < content.length
            if brace_depth.zero? && content[index, delimiter.length] == delimiter
              return index unless delimiter.start_with?("$") && escaped?(content, index)
            end

            if content[index] == "\\"
              index += 2
              next
            end

            if content[index] == "{"
              brace_depth += 1
            elsif content[index] == "}" && brace_depth.positive?
              brace_depth -= 1
            end

            index += 1
          end

          nil
        end

        def valid_block_dollar_opener?(content, index)
          !escaped?(content, index) && content[index + 2] != "$"
        end

        def valid_inline_dollar_opener?(content, index)
          return false if escaped?(content, index)
          return false if content[index + 1] == "$"
          return false if whitespace?(content[index + 1])

          previous = index.zero? ? nil : content[index - 1]
          previous.nil? || whitespace?(previous) || !word_or_number?(previous)
        end

        def valid_inline_dollar_closer?(content, index)
          return false if escaped?(content, index)
          return false if content[index + 1] == "$"
          return false if whitespace?(content[index - 1])

          following = content[index + 1]
          following.nil? || whitespace?(following) || !word_or_number?(following)
        end

        def escaped?(content, index)
          slash_count = 0
          cursor = index - 1

          while cursor >= 0 && content[cursor] == "\\"
            slash_count += 1
            cursor -= 1
          end

          slash_count.odd?
        end

        def whitespace?(char)
          char.nil? || char.match?(/\s/)
        end

        def word_or_number?(char)
          !char.nil? && char.match?(/[A-Za-z0-9_]/)
        end

        def convert_alerts(html)
          fragment = Nokogiri::HTML.fragment(html)
          fragment.css("blockquote").reverse_each do |blockquote|
            convert_alert_blockquote(blockquote)
          end
          fragment.to_html
        end

        def convert_alert_blockquote(blockquote)
          first_child = blockquote.element_children.first
          return unless first_child&.name == "p"

          match = first_child.inner_html.match(ADMONITION_RE)
          return unless match

          type = match[1].downcase
          options = match[2].to_s.downcase.split(/[,\s]+/)
          state = match[3]
          title = match[4].strip
          icon = ADMONITIONS.fetch(type)
          inline = options.include?("inline")
          title = type.capitalize if title.empty? && !inline

          blockquote.replace(admonition_node(blockquote, first_child, type, icon, state, title, inline))
        end

        def admonition_node(blockquote, title_source, type, icon, state, title, inline)
          document = blockquote.document
          collapsible = !state.nil? && !inline
          container = Nokogiri::XML::Node.new(collapsible ? "details" : "blockquote", document)
          classes = ["admonition", "admonition-#{type}"]
          classes << "admonition-inline" if inline
          container["class"] = classes.join(" ")
          container["open"] = "open" if state == "+"

          container.add_child(admonition_title_node(document, collapsible, icon, title)) unless inline
          if inline && !title.empty?
            title_source.inner_html = title
          else
            title_source.remove
          end
          container.add_child(admonition_body_node(document, blockquote))
          container
        end

        def admonition_title_node(document, collapsible, icon, title)
          title_node = Nokogiri::XML::Node.new(collapsible ? "summary" : "div", document)
          title_node["class"] = "admonition-title"
          title_node.inner_html = %(<i class="admonition-icon fa-solid fa-#{icon}" aria-hidden="true"></i><span class="admonition-title-text">#{title}</span>)
          title_node
        end

        def admonition_body_node(document, blockquote)
          body = Nokogiri::XML::Node.new("div", document)
          body["class"] = "admonition-body"
          blockquote.children.to_a.each do |child|
            body.add_child(child.unlink)
          end
          body
        end

        def restore_math(html, math_spans)
          math_spans.reduce(html) do |output, span|
            output.gsub(span["token"], canonical_math(span))
          end
        end

        def canonical_math(span)
          body = CGI.escapeHTML(span["body"])
          span["display"] ? "\\[#{body}\\]" : "\\(#{body}\\)"
        end
      end
    end
  end
end
