# Blog

A Jekyll blog using the same visual style and two-column layout as `keyijing.github.io`.

## Structure

```text
_config.yml              # Site-wide Jekyll settings: title, metadata, permalink style, plugins, post defaults.
Gemfile                  # Ruby dependencies for GitHub Pages-compatible local builds.
Gemfile.lock             # Locked Ruby dependency versions for reproducible local builds.
index.md                 # Homepage entry point; its Markdown body is the left-column blog introduction.
.github/workflows/pages.yml
                          # GitHub Pages deployment workflow using the Ruby/Jekyll build.
_plugins/
  math_protected_kramdown.rb
                          # Protects math during Markdown parsing and converts GitHub-style alerts.
_layouts/
  default.html           # Base HTML shell: document head, CSS, icon CDNs, KaTeX, feed metadata, SEO metadata.
  home.html              # Homepage layout: left-column `index.md` content and newest-to-oldest post cards.
  post.html              # Individual post layout: single-column post title, date, tags, and Markdown body.
welcome/
  index.md               # Example Markdown blog post.
  example.txt            # Example post attachment stored beside the post.
feed/
  blog.xml               # Atom feed generated from pages marked `post: true`.
_sass/
  main.scss              # All site styling: source-style layout, sidebar typography, post cards, post body, responsive rules.
assets/
  css/style.scss         # Jekyll Sass entry point; imports `_sass/main.scss`.
```

Generated folders such as `_site/`, `.sass-cache/`, and `.jekyll-cache/` are ignored and should not be edited by hand.

## Write a Post

Create a folder at the site root, then put the post body in `index.md`:

```text
your-title/index.md
```

The post name can include multiple directory levels:

```text
notes/jekyll/your-title/index.md
```

Use front matter at the top:

```yaml
---
layout: post
post: true
title: "Your Title"
date: 2026-05-01
listed: true
description: "Shown on the homepage with **inline Markdown**."
tags:
  - notes
---
```

The homepage lists every page marked `post: true` automatically, sorted by `date` from newest to oldest.

Put post-specific attachments next to `index.md`:

```text
your-title/image.png
your-title/notes.pdf
```

## Behavior

- Posts are regular Jekyll pages stored at `<name>/index.md` from the site root.
- `<name>` may be a single folder such as `your-title` or a nested path such as `notes/jekyll/your-title`.
- Mark a page with `post: true` so the homepage and feed treat it as a blog post.
- Files next to a post's `index.md` are copied beside the rendered page, so `welcome/example.txt` becomes `/welcome/example.txt`.
- Post folder names do not include dates; use front matter `date: YYYY-MM-DD` for both sorting and display.
- The homepage sorts posts by front matter `date` in descending order, so newer posts appear first.
- Set `listed: false` in a post's front matter to keep it published at its URL but hide it from the homepage list.
- Homepage post cards render `description` with inline Markdown support, such as `**bold**`, `code`, and links.
- Individual posts use `_layouts/post.html` and render as a single-column reading page without the homepage sidebar.
- The Atom feed for blog posts is rendered by `feed/blog.xml` at `/feed/blog.xml`.
- Markdown is rendered by a local Jekyll processor that protects math before kramdown parses the page.
- Math rendering is provided by browser-side KaTeX in `_layouts/default.html` and supports `$...$`, `$$...$$`, `\(...\)`, and `\[...\]`.
- GitHub-style alerts such as `> [!NOTE]`, `> [!TIP]`, `> [!SUCCESS]`, and `> [!IDEA]` are converted to styled admonitions during Markdown rendering.

## Customization

| What to change | File |
|---|---|
| Left sidebar Markdown content / blog introduction | `index.md` |
| Homepage post listing layout | `_layouts/home.html` |
| Individual post page layout | `_layouts/post.html` |
| Base HTML, CSS/CDN links, KaTeX setup, SEO/feed tags | `_layouts/default.html` |
| Markdown rendering behavior | `_plugins/math_protected_kramdown.rb` |
| Site title, description, repository, permalink style, plugins | `_config.yml` |
| Colors, spacing, post card hover state, responsive behavior | `_sass/main.scss` |
| Sass import entry point | `assets/css/style.scss` |
| Blog posts and post attachments | `<name>/` |

The homepage intentionally renders only the `index.md` sidebar introduction and the post list. Individual posts use a single-column layout without the homepage sidebar.

## Local Development

```bash
bundle install
bundle exec jekyll serve
```

The site will run at `http://localhost:4000`.

To produce a production build:

```bash
bundle exec jekyll build
```

The project keeps the `github-pages` gem for dependency compatibility, but does not load the `github-pages` plugin wrapper; this lets the local `_plugins/` Markdown processor run in GitHub Actions.
