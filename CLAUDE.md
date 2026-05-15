# CLAUDE.md — billederapport.dk

Project-level instructions for this repo. The global `~/.claude/CLAUDE.md` rules still apply (GitHub issues for tasks, Context7 for library docs, feature branches, etc.).

## What this repo is

Static, single-file marketing site for [Billederapport](https://app.billederapport.dk), hosted on GitHub Pages. The actual product lives at `app.billederapport.dk` — this repo is *only* the landing page. No build step, no framework, no client-side JS beyond the footer year and Umami analytics.

## Design system — always loaded

@design.md

Match the tokens, components, spacing, voice and accessibility rules in `design.md` for any visual or copy change. If you need a new color/radius/shadow, add it to `:root` in `index.html` *and* document it in `design.md` in the same change.

## Working in this repo

- Edits land in `index.html` (markup + inline CSS + JSON-LD structured data). There is no `styles.css` despite what the README says — styles live inline for first-paint performance.
- Keep the page as a single HTML file with inline CSS. Do not split out a stylesheet or introduce a bundler.
- Keep `lang="da"`. All user-facing copy in Danish.
- Update `llms.txt`, `llms-full.txt`, `sitemap.xml`, and the JSON-LD `@graph` if you add/rename sections, change pricing, or update the FAQ.
- After any change, sanity-check both light and dark color schemes, and 360px / 760px / 1200px widths.

## Local preview

```bash
python3 -m http.server 4000
```

Then open <http://localhost:4000>.

## Deployment

GitHub Pages serves `main` from repo root. `CNAME` points `billederapport.dk` at Pages. Pushing to `main` is the deploy — there is no staging.
