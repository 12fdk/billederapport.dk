# Billederapport — Design System

The single source of truth for the visual language of `billederapport.dk`. Match this when adding or editing UI. All tokens live inline in `index.html` under `:root` — keep them in sync with this document.

## Design principles

- **Warm, paper-like surfaces, not stark white.** The light theme uses a cream/paper palette (`#F5F1EA`) instead of `#FFFFFF` to read as Danish, calm, and craft-oriented.
- **One accent, used sparingly.** Orange (`#E8833A`) signals action and highlights only — CTAs, eyebrows, focus rings, step numbers, photo annotations. Never decorative.
- **Soft depth, no flat cards.** Use the layered shadow tokens; avoid 1px borders alone for elevation.
- **Mobile-first phrasing.** Hero copy, CTAs, and visuals assume a phone in the field. The product *is* a phone app, so the marketing should look like one too.
- **Quiet motion.** Subtle hover lifts (translateY −2px), 0.15s eases. Respect `prefers-reduced-motion`.
- **Bilingual-ready but Danish-first.** All copy in Danish (`lang="da"`). Currency in DKK. No translations infrastructure.

## Color tokens

Defined in `index.html` `:root`. Reference via `var(--token)` — never hardcode hex in new rules.

### Ink (text / dark UI)
| Token | Light | Role |
| --- | --- | --- |
| `--ink` | `#1a2332` | Primary text, dark surfaces |
| `--ink-soft` | `#3a4657` | Secondary text |
| `--ink-muted` | `#677184` | Tertiary / labels |

### Paper (backgrounds)
| Token | Light | Role |
| --- | --- | --- |
| `--paper` | `#f5f1ea` | Page background |
| `--paper-soft` | `#faf6ef` | Alt section background |
| `--paper-strong` | `#ece6db` | Stronger paper surface |

### Accent (orange)
| Token | Value | Role |
| --- | --- | --- |
| `--accent` | `#e8833a` | Primary CTA fill, photo annotation strokes |
| `--accent-strong` | `#d37128` | Hover state, icon foregrounds on light |
| `--accent-text` | `#b5541e` | Accent text on paper (AA contrast) |
| `--accent-soft` | `#fff2e6` | Tinted icon backgrounds |
| `--ring` | `rgba(232, 131, 58, 0.35)` | Focus outline |

### Dark mode
| Token | Value | Role |
| --- | --- | --- |
| `--dark-bg` | `#0e1520` | Page background |
| `--dark-surface` | `#141c2a` | Card surface |
| `--dark-surface-2` | `#1c2637` | Alt section / stronger paper |
| `--dark-border` | `#27344a` | Border |

Dark mode overrides text to `#eef1f6`, muted to `#8b97ad`, and shifts `--accent-text` back to `--accent` (orange reads fine on the navy ground).

### Semantic aliases
- `--bg`, `--surface`, `--surface-2`, `--text`, `--text-muted`, `--border` swap by color scheme. Always prefer these over the raw paper/dark tokens in component rules.

## Typography

- **Font:** `InterVariable` (self-hosted, `font-display: swap`), preloaded. System-font stack as fallback. Variable axis covers `100–900`.
- **Stylistic sets enabled on `body`:** `cv11`, `ss01`, `ss03` via `font-feature-settings`. Keeps `1`/`l`/`I` distinguishable and the alt single-storey `a`.
- **Base size:** `17px` body, `1.55` line-height. Smoothing enabled (`-webkit-font-smoothing: antialiased`).
- **Headings:** `letter-spacing: -0.02em`, `font-weight: 700`, `line-height: 1.15`.
  - `h1`: `clamp(2.1rem, 2.2vw + 1.6rem, 3.6rem)`, tighter `-0.028em`.
  - `h2`: `clamp(1.6rem, 1.2vw + 1.2rem, 2.4rem)`.
  - `h3`: `1.125rem`.
- **Eyebrow:** `0.825rem`, uppercase, `letter-spacing: 0.1em`, `--accent-text`, sits above each section heading.
- **Lede:** `1.0625rem`–`1.125rem`, `--text-muted`, capped at ~36–52ch.

## Spacing & layout

- **Container:** `max-width: 1160px`, horizontal padding `clamp(1rem, 2vw, 2rem)`.
- **Section vertical rhythm:** `clamp(4rem, 8vw, 7rem)` top/bottom. Alternating sections use `.section-alt` (background `--surface-2`).
- **Section-head:** centered, max 720px, ~3rem bottom gap.
- **Sticky header:** 68px nav, translucent `color-mix(... --bg 85%, transparent)` + `backdrop-filter: blur(14px)`.
- **Smooth scroll:** `scroll-padding-top: 84px` so anchors clear the sticky header.

## Radii & shadows

| Token | Value | Use |
| --- | --- | --- |
| `--radius-sm` | `8px` | Pills, small chips |
| `--radius` | `14px` | Buttons, inputs |
| `--radius-lg` | `18px` | Feature cards, step cards |
| `--radius-xl` | `26px` | Plan card, quote card |

Phone mock uses a custom `44px` outer / `32px` inner radius.

| Token | Value | Use |
| --- | --- | --- |
| `--shadow-sm` | 1+2px stack at low alpha | FAQ items at rest |
| `--shadow` | 4+20px stack | Card hover, quote, hero card |
| `--shadow-lg` | `0 20px 60px rgba(26,35,50,0.18)` | Reserved for larger floating elements |

## Components

### Buttons (`.btn`)
- Base height `44px`, padding `0 1.1rem`, radius `--radius`, weight 600.
- `.btn-primary` — accent fill, ink text. Hover → `--accent-strong`.
- `.btn-ghost` — transparent, bordered with `--border`, hover fills `--surface-2`.
- `.btn-lg` — height `52px`, radius `--radius-lg`. Use for hero/CTA blocks.
- `.btn-block` — `width: 100%`. Used inside the plan card.
- Active state: `transform: scale(0.985)`. Focus-visible: 3px ring (`--ring`).

### Header / nav
- Sticky, translucent, blurred. Brand mark swaps between `logo-color.svg` (light) and `logo-dark.svg` (dark) via `prefers-color-scheme`.
- Nav links hidden below `760px` viewport; nav actions become pill-bordered chips on mobile.
- Below `400px` the brand name text hides — only the logo mark remains.

### Hero
- Two-column grid above `900px` (`1.05fr 1fr`), single-column below.
- Background uses two layered radial accent gradients (top-left bigger, top-right faint).
- Right column is a **real framed iPhone screenshot** (`.phone` wraps a `<picture>` with AVIF + WebP). The phone is rotated `-2°`; the tilt flattens at `≤480px` and under `prefers-reduced-motion`. Drop-shadow comes from `filter: drop-shadow(...)` so the rounded phone frame casts a soft, frame-shaped shadow (not a rectangle).
- The image is eager + `fetchpriority="high"` because it's the LCP element. Source PNGs (1350×2760, ~500 KB each) are pre-resized to 720px wide and encoded as AVIF (~26 KB) and WebP (~40 KB).
- A floating "PDF sendt" `.hero-card` overlaps the bottom-left of the phone above `900px`; stacks below the phone on smaller widths.
- Trust points: bullet list with accent checkmark SVGs.

### Phone screenshot (`.phone`)
- Container for a single framed iPhone screenshot in the hero. Just a `<picture>` wrapper — no chassis or notch in CSS; the frame is baked into the source PNG.
- `filter: drop-shadow(...)` (not `box-shadow`) so the soft shadow follows the rounded phone outline.
- Source images live in `assets/screenshots/` and come from the app repo's framed Playwright shots (`output-framed/iphone-16-pro/…`). Don't bake a phone frame in CSS again; the framed PNGs are the canonical source.

### Strip / social proof
- Thin band, `--surface-2` background, top/bottom borders.
- Inline list of categories (Ejendom, Skader & forsikring, Byggeri, Service, Rådgivning) with accent-stroked icons.

### Feature cards (`.feature`)
- 3-up grid above ~860px, `auto-fit minmax(260px, 1fr)`.
- Padding `1.5rem`, radius `--radius-lg`, 44×44 accent-soft icon tile with `--accent-strong` stroke.
- Hover: `translateY(-2px)`, gain `--shadow`, border tints toward accent (`color-mix(... --accent 30%, --border)`).

### Steps (`.step`)
- Numbered circle badge (`--ink` background, paper text; flips to accent in dark mode) anchored at top-left, overlapping the card by 16px.
- Same card chrome as features.

### Why / quote
- Two-column grid above `900px` (`1.1fr 0.9fr`).
- `.why-list` uses small accent-dot bullets, `strong` highlights the lead phrase.
- `.quote-card` — radius `--radius-xl`, large accent quote glyph, italic-feeling weight-500 body, attribution muted.

### Pricing
- Single plan (`.plans-single`, max 440px). The card is always "featured": tinted accent border + outer accent ring via dual shadow.
- `.plan-amount` 2.5rem 800-weight, `.plan-unit` muted.
- Checklist items prefixed by a CSS-drawn accent checkmark (rotated borders, no icon font).

### Screenshots gallery / carousel (`.carousel` + `.shots-grid`)
- Sits between the **Why** section and **Pricing**, with `.section-alt` background.
- A pill-style `.device-toggle` above the carousel switches between **Mobil / Tablet / Desktop** by rewriting each `<picture>`'s `srcset`. Each `.shot` carries `data-mobile-*`, `data-tablet-*`, `data-desktop-*` attributes the script reads from.
- The `.shots-grid` itself is a horizontal flex carousel (not a grid) with `scroll-snap-type: x mandatory`. Visible-item counts per device: **3 mobile / 2 tablet / 1 desktop**, computed as `flex: 0 0 max(<floor>, calc((100% - <gap-sum>) / N))` so very narrow viewports fall back to a minimum item width and the rest scrolls.
- Round `.carousel-arrow` buttons sit on the left/right edges of `.carousel` (44×44, paper-on-paper at rest, ink-on-paper on hover). Disabled when at the start/end. They scroll the track by one item via `scrollBy`. Respects `prefers-reduced-motion` by switching to instant scroll.
- Each `.shot` is a framed device `<picture>` (AVIF + WebP, lazy-loaded) plus a centred `.shot-caption` with `<h3>` title + 1-line `<p>` description (≤ 15 words, ≤ 32ch).
- No card chrome — just `filter: drop-shadow(...)` on `.shot-img` so the shadow follows the rounded device outline. The framed PNGs carry the visual weight.
- Source PNGs live in the app repo under `tests/screenshots/output-framed/{iphone-16-pro,ipad-pro,desktop}/…`. Pre-resize new ones to 500/600/900 px wide respectively and encode AVIF + WebP. Keep per-form-factor weight under ~250 KB per format.

### FAQ
- `<details>` / `<summary>` per item, no JS toggles. Sits in a `.section-alt` background so the white `--surface` items pop.
- Chevron rotates 180° on `[open]`, color shifts to `--accent-text`. Open state tints the border and upgrades to `--shadow`.
- Focus outline on summary uses the accent ring at 2px offset.

### CTA section
- Centered, paper background with a top-fading accent radial gradient (`90% 70% at 50% 0%`).
- Same button pair as the hero (primary + ghost).

### Footer
- `--surface-2` background, three columns above `680px` (brand col is `1.4fr`, then two `1fr` link cols).
- Footer-bottom band separated by a border, `0.825rem` text — copyright left, "Hostet i EU · GDPR-venlig" right.

## Iconography

- All icons are inline `<svg>` with `stroke="currentColor"`, `stroke-width: 1.6` (1.4–2.25 for specific contexts), `stroke-linecap="round"`, `stroke-linejoin="round"`, `fill="none"` unless intentionally filled.
- Sized contextually: 18–22px for inline list, 24px for feature tiles, 40–60px for the quote glyph and photo arrow.
- Color inherits from the surrounding text or `--accent` for emphasis. No icon libraries — keep them inline so there's no extra request.

## Imagery

- **Logos:** `assets/logo/logo-color.svg` for light, `assets/logo/logo-dark.svg` for dark. Both 36×36 in nav, 28×28 in footer.
- **Favicon:** `/favicon.ico` (multi-size), 32px PNG and Apple touch icon (180px) for iOS install.
- **OG card:** `assets/og/og-card.png`, 1200×630.
- **Photo mock:** drawn entirely in CSS (gradient slab + SVG annotations). Do not swap for a raster image — it would regress LCP and add weight.

## Accessibility

- `lang="da"` on `<html>`; OG locale `da_DK`.
- Skip link (`.skip-link`) positioned off-screen until focused, jumps to `#main`.
- All decorative SVGs carry `aria-hidden="true"`. The phone mock container also.
- Buttons and links have visible focus rings via `box-shadow: 0 0 0 3px var(--ring)`.
- Color contrast: `--accent-text` (`#B5541E`) on `--paper` for any orange copy — meets WCAG AA. Body text is `--ink` on `--paper`, well above AAA.
- `prefers-reduced-motion: reduce` flattens transforms (phone tilt, hero card rotation) and zeros transitions.

## Performance

- Single-file HTML (~64KB), inline CSS, inline structured data, one tiny script for the footer year + the Umami analytics tag.
- Font preloaded; Latin-subset `InterVariable-v2.woff2`. Filename is intentionally versioned to bust Cloudflare edge cache when the file changes.
- `dns-prefetch` for `app.billederapport.dk` and the Umami host.
- No client-side JS framework. Do not introduce one for marketing-page features — write CSS or static HTML instead.

## Voice & content

- **Danish, conversational, tradesperson-respectful.** Short sentences, plain words. Avoid SaaS jargon ("seamless", "synergy", "platform").
- **Speak to the field user, not the buyer-persona.** Examples: "Også når der ikke er dækning.", "Designet til store handsker, kolde fingre og skarpt sollys."
- Section eyebrows in uppercase Danish ("Funktioner", "Sådan virker det", "Pris", "Spørgsmål & svar").
- CTAs use verbs and value, not generic "Learn more": "Prøv gratis i 14 dage", "Åbn appen", "Opret konto gratis".
- Prices always show "kr / md" with "ekskl. moms" footnote.

## When making changes

- Keep the design language consistent — new sections should reuse existing component patterns (feature card, step, plan, quote) rather than invent new chrome.
- If a new token is genuinely needed, add it to `:root` in `index.html` *and* document it here.
- Test in both light and dark mode (macOS toggle is fastest).
- Test at 360px, 760px, 1200px widths at minimum. The 480px and 900px breakpoints are the load-bearing ones.
- After any visual change: serve the folder (`python3 -m http.server 4000`) and eyeball it in a real browser, not just in code.

---

## Optimizations & explicit rules

The rules below were gathered from auditing the site against well-formed public design systems (Genesis, ShopVibe, DocuForge, Verdana Health, CreateSpace, NomadKit). They tighten things that were previously implicit. When in doubt, follow these.

### Spacing — declare an 8px grid

All padding, margin, and gap values should land on a single 8px-based scale. Existing `clamp()` rules can stay (they collapse to scale stops at the inner breakpoint), but new rules must pick from the scale:

```
4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96, 128 px
```

Don't invent intermediate values like `13px` or `1.7rem`. The 4px stops (`4`, `12`, `20`) exist for fine-grained pill / chip work — prefer 8px multiples for layout.

### Type — cap weights and weights-per-screen

- Inter Variable has every weight from 100 to 900 — that's a trap. Use **only**: 400 (body), 500 (links/labels), 600 (eyebrow / nav / button), 700 (headings). Anything heavier than 700 is reserved for the plan price (currently 800).
- **No more than three distinct weights in a single section.** If a section already uses 400/600/700, don't add 500 just to nudge a label.
- **Tabular numerals** for any aligned numerics (price `199`, timestamps like `kl. 10:34`, dates like `24-04-2026`). Add `font-feature-settings: 'tnum' 1, 'cv11', 'ss01', 'ss03';` to `.plan-amount`, `.photo-timestamp`, `.hero-card-sub`, and any future stats. Without `tnum`, Inter's proportional digits make prices look wobbly.

### Prose width

Body paragraphs should never exceed **~68 characters per line** (`max-width: 68ch` or ~640px). Current ledes already cap at 36–52ch — that stays. The rule applies to long-form copy if any is added later (changelog, blog, terms). FAQ answers currently span the full 820px container; consider `max-width: 70ch` inside `.faq-item p` if answers grow.

### Line-height

- Headings: `1.15` (already set).
- Body / ledes: `1.55` (already set).
- Long paragraphs (FAQ answers, future blog content): `1.65–1.7`. FAQ already uses `1.65`. Keep that as the floor for paragraph blocks longer than ~3 lines.

### Accent discipline — one rule, no exceptions

`--accent` (`#E8833A`) is reserved for:

1. Interactive surfaces (primary button fill, focus ring, hover tints).
2. Wayfinding emphasis (eyebrows via `--accent-text`, step number in dark mode, FAQ open state, plan badge).
3. The single decorative gradient blob behind the hero and CTA sections.

It must **not** appear as: decorative dividers, body-copy emphasis, generic illustration fills, or random "splash" backgrounds in new sections. If a new section needs visual lift, prefer `--surface-2` alternation or a soft shadow — not more orange.

### One primary action per viewport

In any single viewport (hero, pricing, final CTA) there is **exactly one** `.btn-primary`. A `.btn-ghost` next to it is fine and expected. Two filled accent buttons compete and cheapen the click. The current layout already follows this — codifying it so it stays that way.

### Motion budget

- **One animated thing per viewport.** The hero's tilted phone is the only motion in the fold. Don't add hover-bouncing icons, marquee strips, or scroll-triggered fades on top of it.
- **Duration:** transitions stay between **80ms and 200ms** (`0.08s–0.2s`). The existing `0.08s` button press and `0.15s` card hover are the canonical values. No 400ms+ "theatrical" eases.
- **Easing:** plain `ease` is fine for this scale. Don't introduce cubic-bezier curves without a reason.
- `prefers-reduced-motion: reduce` already zeros transitions and flattens transforms. Any new animation must respect that branch.

### Semantic status tokens (add when needed)

We currently bake the pill colors into `.pill-ok` (green) and `.pill-no` (orange). If any new component needs success/warning/error/info, **add tokens** rather than re-inventing colors:

```css
--success: #1f6f3a;       /* darker green, AA on paper */
--success-soft: #d6f0dc;
--warning: #9a4414;       /* the existing pill-no foreground */
--warning-soft: #fde3d1;
--danger: #b91c1c;
--danger-soft: #fde2e2;
--info: var(--accent-text);
```

Add these only when the first new component actually needs them — don't speculate. Keep dark-mode pairs in the dark-mode override block.

### Focus indicators

Every interactive element must show a visible focus ring. The existing `box-shadow: 0 0 0 3px var(--ring)` on `.btn:focus-visible` is the canonical style. Apply the same treatment to:

- Footer links and nav links (currently rely on browser default outline — fine, but inconsistent).
- `.link` in the nav-actions row.
- Any future `<input>` or `<textarea>`.

Use `:focus-visible`, not `:focus`, so mouse clicks don't strobe the ring.

### Image / asset hygiene

- **No raster decoration.** The phone mock and all icons are SVG/CSS so the page stays under one HTTP roundtrip + the font. If a hero photo is ever added, it must use `loading="eager"` + `fetchpriority="high"` + AVIF/WebP, sized to the actual layout (no 4000px sources).
- **No popups, ever.** No newsletter modal, cookie banner overlay, intent-exit prompt. The site is single-purpose; interruption kills trust. (The analytics tag is Umami, which doesn't need a cookie banner under GDPR — keep it that way.)
- **OG card and favicons** are the only raster assets the marketing surface ships. Don't add more.

### Contrast & accessibility floor

- All body and label copy must meet **WCAG AA at minimum** against its background. The existing pairs (`--ink` on `--paper`, `--ink-muted` on `--paper`, `--accent-text` on `--paper`) all pass. New colors must be checked — don't eyeball it.
- **Never rely on color alone** to convey state. The `Ja` / `Nej` pills work because they carry text *and* color. Keep that pattern for any new status indicators.
- **Touch targets ≥ 44×44px.** Current `.btn` is 44px, `.btn-lg` is 52px — good. Footer link rows are tight; ensure any new interactive list keeps a 44px hit area even when the visible text is small.

### No-shadow-on-static rule (with one exception)

Static cards rest on a 1px border + the `--surface` swap. They gain `--shadow` on hover. The exception is the **quote card** and the **plan card**, which both ship with shadow at rest because they are intentional focal points. Don't extend that exception to feature cards or steps — keep them visually quieter than the focal cards.

### Section rhythm

Adjacent full-width sections must alternate background between `--bg` and `--surface-2` (via `.section-alt`). Two `--bg` sections in a row collapse the visual rhythm. Current order — hero → strip(alt) → features → how(alt) → why → skaermbilleder(alt) → pricing → faq(alt) → cta — already does this; preserve it when reordering.

### Copy length budgets

- **H1:** ≤ 9 words. The current hero is 6 — good.
- **Lede:** ≤ 35 words. Current is 30.
- **Feature card body:** ≤ 30 words. Watch this when adding cards — the longest current card ("Før og efter-billeder") is at the ceiling.
- **CTA button label:** ≤ 4 words. Use a verb. No "Click here" / "Learn more".

### Things to never do on this site

- Add a hamburger menu. Nav has four items — they fit, and a hamburger on a 5-link nav is admitting defeat.
- Introduce a CSS framework (Tailwind, Bootstrap, etc.) or a JS framework. The site is a single static file; that's the feature.
- Add a chat-widget, intercom bubble, or "AI assistant" floater. The product is the link; the page sells it.
- Use stock photography of generic "professionals shaking hands". The CSS phone mock is the brand visual.
- Use lorem ipsum, even temporarily. Write real Danish copy or leave the section out.
