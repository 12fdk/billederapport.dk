# billederapport.dk

Static landing page for [Billederapport](https://app.billederapport.dk), hosted on GitHub Pages.

It's a marketing site only — the actual app lives at `app.billederapport.dk`.

## Structure

```
billederapport.dk/
├── index.html          # single-page landing site (Danish)
├── styles.css          # hand-written CSS using the app's brand tokens
├── CNAME               # custom domain for GitHub Pages
├── .nojekyll           # disable Jekyll processing on GH Pages
├── robots.txt
├── sitemap.xml
└── assets/logo/        # logo + favicon assets copied from the app
```

## Local preview

No build step. Serve the folder with any static server:

```bash
python3 -m http.server 4000
# or
npx serve .
```

Open http://localhost:4000.

## Deployment (GitHub Pages)

1. Push this repo to GitHub.
2. In the repo settings → **Pages**, pick **Deploy from a branch** and select `main` / `/ (root)`.
3. DNS: point `billederapport.dk` at GitHub Pages:
   - `A` records for `@` → GitHub Pages IPs (185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153), **or**
   - `CNAME` for `www` → `<username>.github.io`.
4. The `CNAME` file at the repo root tells GitHub Pages which custom domain to use.
5. Enable **Enforce HTTPS** in the Pages settings once the cert is issued.

## Brand tokens

Pulled from `app.billederapport.dk/logo/README.md`:

| Token   | Value     | Role                        |
| ------- | --------- | --------------------------- |
| ink     | `#1A2332` | text / dark UI              |
| paper   | `#F5F1EA` | light background            |
| accent  | `#E8833A` | CTAs and highlights         |
| dark-bg | `#0E1520` | dark mode background        |

If the app's brand ever changes, update `styles.css` (`:root` tokens) and replace
the files in `assets/logo/`.
