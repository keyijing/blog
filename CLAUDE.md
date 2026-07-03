# CLAUDE.md

## Project Overview

Jekyll-based Markdown blog using the visual style of `keyijing.github.io`. See `README.md` for full architecture, file structure, and styling details.

## Coding Guidance

- Prefer editing existing files over creating new ones.
- Keep the blog introduction/sidebar prose in Markdown (`index.md`).
- Do not use `_data/homepage.yml` or `_includes/inline-md.html`; those belonged to the source homepage project and are not part of this blog.
- Keep each blog post in `<name>/index.md` at the site root, with front matter for `layout: post`, `post: true`, `title`, `date`, optional `description`, and optional `tags`.
- Allow `<name>` to contain multiple directory levels, such as `notes/jekyll/my-post/index.md`.
- Keep post folder names free of dates; sorting and display dates come from front matter.
- Store post-specific attachments next to that post's `index.md`.
- The homepage and feed discover posts by filtering `site.pages` for `post: true`.
- Render homepage `description` fields with inline Markdown support.
- Use SCSS variables (`$primary`) and CSS custom properties (`--primary`) for colors; keep them in sync.
- Primary color `#0070f3` is for links and hover states, not standalone headings.
- Load icons via CDN; don't bundle icon fonts locally.
- All links open in new tabs via `<base target="_blank">` in `default.html`.
- Math is protected by `_plugins/math_protected_kramdown.rb` before kramdown parses Markdown, then rendered in the browser by KaTeX (`$...$`, `$$...$$`, `\(...\)`, `\[...\]`).
- GitHub-style alerts are converted by `_plugins/math_protected_kramdown.rb`; keep alert styling in `_sass/main.scss`.
- Homepage post cards should stay bordered, compact, and highlighted on hover.

## Blog Notes

- The homepage sidebar content is written directly in `index.md`.
- Post pages are single-column and do not include the homepage sidebar.
- Posts are Markdown files at `<name>/index.md`; the homepage lists them from newest to oldest by front matter `date`.
- Post names may be nested paths, such as `notes/jekyll/my-post`.
- Keep `_layouts` limited to `default.html`, `home.html`, and `post.html`.

## Pre-commit Checklist

- Always update `README.md` and `CLAUDE.md` to reflect any structural or architectural changes before committing.

## Build

```bash
bundle exec jekyll build
bundle exec jekyll serve
```

Uses the `github-pages` gem for dependency compatibility, but does not put it in the `:jekyll_plugins` group because the local `_plugins` Markdown processor must load during builds.
