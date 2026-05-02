---
layout: post
post: true
title: "Welcome"
date: 2026-04-30
listed: false
description: "A first **Markdown** post with inline links like [Jekyll](https://jekyllrb.com/)."
tags:
  - notes
  - markdown
---

This post is a compact Markdown test page. Add new articles by creating folders at the site root with names like:

```text
your-title/index.md
```

Nested post names are supported too:

```text
notes/jekyll/your-title/index.md
```

Each post starts with front matter:

```yaml
---
layout: post
post: true
title: "Your Title"
date: 2026-05-01
listed: true
description: "One short sentence for the homepage, with **inline Markdown**."
tags:
  - notes
  - markdown
---
```

Then write the article body in regular Markdown. Attachments for this post can live next to `index.md`, for example:

```text
your-title/image.png
your-title/notes.pdf
```

This post includes a small [example attachment](example.txt) stored beside its `index.md`.

## Text

Markdown supports **bold**, *italic*, `inline code`, ~~strikethrough~~, and links such as [keyijing.github.io](https://keyijing.github.io).

> A short blockquote keeps quoted notes visually distinct.

## Lists

- Unordered item
- Another item with **emphasis**
- A nested-looking thought can stay as a normal flat item

1. First ordered item
2. Second ordered item
3. Third ordered item

## Code

```python
def greet(name):
    return f"Hello, {name}!"
```

## Table

| Item | Value |
|---|---:|
| Apples | 3 |
| Oranges | 5 |
| Total | 8 |

## Math

Inline math such as $a^2 + b^2 = c^2$ and display math both work:

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

## Horizontal Rule

---

End of the Markdown rendering test.
