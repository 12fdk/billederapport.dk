#!/usr/bin/env bash
#
# Render pages of the demo PDF report into AVIF + WebP previews for the
# marketing site, and copy the source PDF in for download. Companion to
# scripts/import-screenshots.sh.
#
# Source file lives at:
#   $APP_REPO/sites/app/tests/screenshots/demo-report/output/<file>.pdf
# produced by the app repo's demo-report Playwright run.
#
# Output files land in:
#   assets/report/<slug>-page-<n>-<width>.{avif,webp}
#   assets/report/<filename>.pdf    (the source PDF, copied verbatim)
#
# Add or remove slugs/pages by editing the ENTRIES table below.
#
# Usage:
#   scripts/import-report-pdf.sh
#   scripts/import-report-pdf.sh /custom/path/to.pdf
#
# Prereqs (Homebrew on macOS): poppler (pdftoppm), imagemagick, webp.

set -euo pipefail

DEFAULT_SRC="${APP_REPORT_PDF:-/Users/robert/Git/Billederapport/app.billederapport.dk/sites/app/tests/screenshots/demo-report/output/Bygningsgennemgang_Sokrogvej_7.pdf}"
SRC="${1:-$DEFAULT_SRC}"
DST="$(cd "$(dirname "$0")/.." && pwd)/assets/report"

# slug | source-pdf basename pattern | which pages to render (space-separated)
#
# Currently only one report. Pages 1, 2, 4 are showcased on the site:
# 1 = branded cover, 2 = inspection content, 4 = critical-severity example.
# Page 3 is rendered too so the script stays generic and a follow-up edit
# can swap which pages the section displays without re-running.
PAGES="1 2 3 4"
SLUG="bygningsgennemgang-sokrogvej-7"

# Render at 200 DPI (≈ 1654×2339 for A4), then resize down. That gives us a
# crisp source for both the 500w mobile crop and the 1200w desktop crop.
RENDER_DPI=200
WIDTHS="500 1200"

# Quality knobs mirror the screenshots script: higher quality on the larger
# variant because the visible size is bigger; lower on mobile to keep weight
# tight. The PDF pages are mostly white with text, so even q=60 AVIF looks
# clean.
WEBP_Q_SMALL=85
AVIF_Q_SMALL=60
WEBP_Q_LARGE=85
AVIF_Q_LARGE=65

die() { echo "error: $*" >&2; exit 1; }

[ -f "$SRC" ] || die "source PDF not found: $SRC
       set APP_REPORT_PDF=… or pass the path as the first argument"

for bin in pdftoppm magick cwebp; do
  command -v "$bin" >/dev/null || die "$bin not in PATH (install with: brew install poppler imagemagick webp)"
done

mkdir -p "$DST"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "[$SLUG]"

# Render the requested pages once, at high DPI, to PNGs in tmp_dir.
# pdftoppm emits files like <prefix>-1.png, <prefix>-2.png, …
for page in $PAGES; do
  pdftoppm -r "$RENDER_DPI" -f "$page" -l "$page" -png \
    "$SRC" "$tmp_dir/raw"
done

encode() {
  local src=$1 base=$2 width=$3
  local webp_q avif_q
  if [ "$width" -le 600 ]; then
    webp_q=$WEBP_Q_SMALL; avif_q=$AVIF_Q_SMALL
  else
    webp_q=$WEBP_Q_LARGE; avif_q=$AVIF_Q_LARGE
  fi
  local tmp="$DST/${base}.tmp.png"
  magick "$src" -resize "${width}x" -strip "$tmp"
  cwebp -quiet -q "$webp_q" "$tmp" -o "$DST/${base}.webp"
  magick "$tmp" -quality "$avif_q" "$DST/${base}.avif"
  rm "$tmp"
  printf "    %-46s  %sw\n" "${base}.{avif,webp}" "$width"
}

total=0
for page in $PAGES; do
  # pdftoppm zero-pads only if more than 9 pages — for ≤9 it's just "-1".
  raw="$tmp_dir/raw-${page}.png"
  [ -f "$raw" ] || die "rendered page missing: $raw"
  for width in $WIDTHS; do
    base="${SLUG}-page-${page}-${width}"
    encode "$raw" "$base" "$width"
    total=$((total + 1))
  done
done

# Copy the source PDF verbatim so the site can link to it as a download. We
# preserve the original filename — it's what the user sees in their browser's
# download bar.
pdf_basename="$(basename "$SRC")"
cp "$SRC" "$DST/$pdf_basename"
pdf_size=$(stat -f %z "$DST/$pdf_basename" 2>/dev/null || stat -c %s "$DST/$pdf_basename")
printf "    %-46s  %s bytes\n" "$pdf_basename" "$pdf_size"

echo
total_files=$((total * 2))
echo "Wrote ${total_files} image files (${total} variants × 2 formats) + 1 PDF to ${DST#$(pwd)/}/"
