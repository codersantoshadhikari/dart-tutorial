# Dart Tutorial — www.dart-tutorial.dev

Two free courses built with [Hugo](https://gohugo.io/):

- **Dart**: 107 lessons in 15 chapters.
- **Flutter**: moved to its own site, **flutter.dart-tutorial.dev** (separate project folder `flutter-site`). Every old `/flutter/...` URL here redirects there with a 301 (see `data/redirects.json`).

An independent Dart and Flutter learning resource.

This version has **no external theme**. Everything (layouts, CSS, JavaScript) is in this
repository, so it builds with a plain `hugo` command and nothing to download.

## Run it

```bash
hugo version        # 0.158 or newer (built and tested with 0.166.0)
hugo server         # http://localhost:1313 with live reload
hugo --gc --minify  # production build into public/
```

The `public/` folder in this repository is a ready-made production build. If your host
serves `public/` directly, upload it as it is. If your host runs Hugo for you
(Netlify, Vercel, Cloudflare Pages, GitHub Actions), set the build command to
`hugo --gc --minify`, the output folder to `public`, and the Hugo version to 0.166.0.

## Folder layout

```text
hugo.toml                 site settings: URL, title, author name and link
content/
  _index.md               home page text and the FAQ
  about.md                about page
  <chapter>/_index.md     a Dart chapter: title, description and order (weight)
  <chapter>/<lesson>.md   a Dart lesson
layouts/
  baseof.html             page shell
  home.html               home page (hero, both courses, FAQ)
  section.html            chapter page, and the Flutter overview page
  page.html               lesson page
  404.html, robots.txt, home.json (search index)
  _partials/              head (SEO tags), schema (JSON-LD), header, sidebar, footer,
                          chapters / lessons / track (which course a page is in)
  _markup/                heading anchors, external links
assets/css/main.css       all styles (design tokens are at the top)
assets/css/syntax.css     code highlighting colours
assets/js/main.js         search, theme, code buttons, progress, mobile menu
static/                   favicon, icons, social image, web manifest
archetypes/default.md     template used by `hugo new`
```

## Add or edit a lesson

```bash
hugo new content collections/my-new-lesson.md          # a Dart lesson
hugo new content flutter/widgets/my-new-lesson.md      # a Flutter lesson
```

Front matter fields:

| Field | Purpose |
| --- | --- |
| `title` | Page heading and `<title>`. Put the main search phrase first, e.g. "Lists in Dart: ..." |
| `linkTitle` | Short name used in the sidebar and navigation |
| `description` | Meta description shown in search results. Keep it 120-160 characters and unique |
| `weight` | Order inside the chapter (1, 2, 3...) |
| `lastmod` | Change this date whenever you update the lesson |
| `keywords` | Extra words the site search should match |
| `aliases` | Old URLs that should redirect here |

Writing conventions:

- Do not add an `# H1` in the body. The template prints the title.
- Use `##` and `###` headings. They form the "On this page" list.
- Dart code goes in ```` ```dart ```` blocks. A block gets a **Run** button (DartPad) when it
  contains `main()`, does not import `dart:io` or `dart:isolate`, and only imports packages
  DartPad supports (`flutter`, `http`, `provider`, `flutter_riverpod`, `flutter_bloc`,
  `go_router`, `shared_preferences`, `google_fonts`, `intl` and a few more; the list is at the
  top of the code-block section in `assets/js/main.js`). A Flutter block must also define
  every page or app class it uses. To stop a block getting a Run or Edit button, put a comment
  containing the words `Not standalone` in it.
- Program output goes in an ```` ```output ```` block.
- Link to other lessons with root-relative paths: `[lists](/collections/lists/)`.

To add a chapter, create a folder with an `_index.md` that has `course: true` and a `weight`.
Put it at the top level of `content/` for Dart, or inside `content/flutter/` for Flutter.

The lesson count is also written by hand in `content/about.md`,
`content/about.md` and `hugo.toml`. Update those when the number changes. Everywhere else
the counts are worked out automatically.

## Screen sizes

All sizes in the CSS are in `rem`, and the base size steps up on very large screens, so the
layout holds from 320 px phones to 4K monitors. Breakpoints: 1180 px (the "On this page"
column folds into the article), 900 px (the lesson menu becomes a slide-in drawer),
640 px and 420 px (single-column and compact spacing).

## Old URLs

Every URL of the previous site (and its `/fr/` copy) redirects to the matching new
lesson through the `aliases` in each file. Do not delete them: they keep existing
Google results and backlinks working.

## SEO: what is built in

- Canonical URL on every page, on `https://www.dart-tutorial.dev/`.
- Unique `<title>` and meta description per page.
- Open Graph and Twitter tags with a 1200x630 share image.
- JSON-LD structured data: WebSite, Person (author), Course, FAQPage, BreadcrumbList,
  TechArticle and CollectionPage.
- `sitemap.xml`, `robots.txt` and an RSS feed, generated on every build.
- Semantic HTML, one H1 per page, breadcrumbs, previous/next links and a full
  lesson menu on every page for internal linking.
- No theme demo pages, no duplicate language copy, no render-blocking scripts.

## SEO update (October 2026)

- Home page targets "Dart tutorial", "learn Dart", "learn Dart and Flutter" (title, H1, text, FAQ).
- Every chapter has a keyword `seoTitle` and a `level` (Beginner / Intermediate / Advanced), shown as a badge.
- New keyword pages: `/learn-dart-and-flutter/` (roadmap), `/getting-started/dart-syntax/`,
  `/getting-started/dart-vs-javascript/`, `/dart-basics/string-methods/`, `/collections/list-methods/`,
  `/next-steps/dart-programming-examples/` (30 programs), `/flutter/next-steps/flutter-examples/` (8 apps).
- Playground is now the "Dart Online Compiler" page with explanatory text.
- `hreflang` en + x-default (one English site for USA, Canada, UK/Europe, Australia, India, Nepal),
  meta keywords, article tags, richer JSON-LD (Course, TechArticle with level, FAQPage), custom sitemap priorities.
- `vercel.json`: real 301 redirects for all old URLs, non-www to www, trailing slash, caching and security headers.
  Re-create it after changing `aliases`: `hugo --gc --minify && python3 scripts/make-vercel-json.py`.
- Search Console / Bing verification: paste codes in `[params.verification]` in `hugo.toml`.
- Social profiles: add URLs to `sameAs` under `[params.author]`.

## SEO: what you need to do after deploying

1. **Redirect** `dart-tutorial.dev` to `https://www.dart-tutorial.dev` with a 301 at
   your host or DNS provider, so only one version is indexed.
2. In **Google Search Console**, add the property, verify it, and submit
   `https://www.dart-tutorial.dev/sitemap.xml`. Do the same in Bing Webmaster Tools.
3. Use "URL inspection" then "Request indexing" for the home page and the chapter pages.
4. **Link to the site** from your GitHub profile and README files,
   LinkedIn, and anywhere you post about Dart or Flutter. Links from other sites are
   the strongest ranking signal and cannot be added from inside this repository.
5. Keep lessons updated and change `lastmod` when you do.

Ranking first for a competitive phrase such as "dart tutorial" takes time and
depends on links and on how useful visitors find the pages. The technical side is in place.

## Changing the author link or site details

Edit `[params.author]` in `hugo.toml`. The name and URL are used in the footer, on
lesson pages, on the home page and in the structured data.

## Run and edit code on the site

Every Dart and Flutter code block gets a button, added by `assets/js/main.js`:

- **Run**: complete programs (they have `main`, and use only packages DartPad supports). The code opens in an embedded DartPad editor and runs. The reader can change it and run it again.
- **Edit**: fragments and partial examples. The editor opens with the code so the reader can complete it and press Run inside the editor.
- No button: code that cannot run in a browser (`dart:io`, isolates, tests, packages DartPad does not ship).
- **Full screen** enlarges the editor. **Open in the playground** moves the code to `/playground/`.

`/playground/` (`content/playground.md`, `layouts/playground.html`) is a full-page editor for the reader's own Dart or Flutter code. The starter examples are the `<script type="text/plain" data-sample="..." data-track="dart|flutter">` blocks in the layout: add one to add an example.

The editor is DartPad (https://dartpad.dev) in an iframe, so it needs an internet connection. Nothing runs on this site's server.
