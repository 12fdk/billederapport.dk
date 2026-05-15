#!/usr/bin/env bash
#
# Pull the latest framed screenshots from the sibling app repo and re-encode
# them as AVIF + WebP at the sizes the marketing site needs (mobile / tablet /
# desktop variants for the carousel, plus the single hero shot).
#
# Source files live at:
#   $APP_REPO/sites/app/tests/screenshots/output-framed/<device>/<flow>/<file>.png
# produced by `make screenshots` in the app repo.
#
# Output files land in:
#   assets/screenshots/<slug>-<size>.{avif,webp}                 (mobile only)
#   assets/screenshots/<slug>-tablet-<size>.{avif,webp}
#   assets/screenshots/<slug>-desktop-<size>.{avif,webp}
#
# Add or remove slugs by editing the ENTRIES table below.
#
# Usage:
#   scripts/import-screenshots.sh
#   scripts/import-screenshots.sh /custom/path/to/output-framed
#
# Prereqs (Homebrew on macOS): imagemagick, webp.

set -euo pipefail

DEFAULT_SRC="${APP_FRAMED_DIR:-/Users/robert/Git/Billederapport/app.billederapport.dk/sites/app/tests/screenshots/output-framed}"
SRC="${1:-$DEFAULT_SRC}"
DST="$(cd "$(dirname "$0")/.." && pwd)/assets/screenshots"

# slug | rel-path under each device dir | mobile-w | tablet-w | desktop-w
# Set a width to '-' to skip that form factor.
ENTRIES=(
  "hero-overview        overview-populated/01-overview-with-data.png   720    -      -"
  "reports-list         reports-list/01-reports-list-default.png       500    1200   1800"
  "report-create        report-create/01-new-report-form.png           500    1200   1800"
  "report-fill-status   report-fill/02-status-pill-selected.png        500    1200   1800"
  "report-fill-photo    report-fill/04-photo-uploaded.png              500    1200   1800"
  "report-send          report-finished/03-send-confirm-dialog.png     500    1200   1800"
  "customer-detail      customer-private/04-customer-detail.png        500    1200   1800"
  "settings-templates   settings/05-settings-templates-standard.png    500    1200   1800"
  "settings-company     settings/02-settings-company.png               500    1200   1800"
)

# Mobile shots display small (max-width ~260 CSS px), tablet/desktop display
# much larger (up to 480/720 CSS px). Higher quality on the larger variants so
# the bigger crops stay sharp on retina; lower on mobile to keep weight tight.
WEBP_Q_MOBILE=82
AVIF_Q_MOBILE=60
WEBP_Q_LARGE=85
AVIF_Q_LARGE=65

die() { echo "error: $*" >&2; exit 1; }

[ -d "$SRC" ] || die "source dir not found: $SRC
       run 'make screenshots' in app.billederapport.dk first"

for bin in magick cwebp; do
  command -v "$bin" >/dev/null || die "$bin not in PATH (install with: brew install imagemagick webp)"
done

mkdir -p "$DST"

device_dir() {
  case "$1" in
    mobile)  echo iphone-16-pro ;;
    tablet)  echo ipad-pro ;;
    desktop) echo desktop ;;
  esac
}

# Naming rule:
#   mobile  -> ${slug}-${width}
#   tablet  -> ${slug}-tablet-${width}
#   desktop -> ${slug}-desktop-${width}
out_name() {
  local slug=$1 kind=$2 width=$3
  case "$kind" in
    mobile)  echo "${slug}-${width}" ;;
    tablet)  echo "${slug}-tablet-${width}" ;;
    desktop) echo "${slug}-desktop-${width}" ;;
  esac
}

encode() {
  local src=$1 base=$2 width=$3 kind=$4
  local webp_q avif_q
  if [ "$kind" = "mobile" ]; then
    webp_q=$WEBP_Q_MOBILE; avif_q=$AVIF_Q_MOBILE
  else
    webp_q=$WEBP_Q_LARGE; avif_q=$AVIF_Q_LARGE
  fi
  local tmp="$DST/${base}.tmp.png"
  magick "$src" -resize "${width}x" -strip "$tmp"
  cwebp -quiet -q "$webp_q" "$tmp" -o "$DST/${base}.webp"
  magick "$tmp" -quality "$avif_q" "$DST/${base}.avif"
  rm "$tmp"
  printf "    %-42s  %sw\n" "${base}.{avif,webp}" "$width"
}

total=0
skipped=0
for line in "${ENTRIES[@]}"; do
  # shellcheck disable=SC2086
  read -r slug rel m_w t_w d_w <<<"$line"
  echo "[$slug]"
  for kind in mobile tablet desktop; do
    case "$kind" in
      mobile)  width="$m_w" ;;
      tablet)  width="$t_w" ;;
      desktop) width="$d_w" ;;
    esac
    [ "$width" = "-" ] && continue

    src="$SRC/$(device_dir "$kind")/$rel"
    if [ ! -f "$src" ]; then
      echo "    SKIP $kind (missing: ${src#$SRC/})" >&2
      skipped=$((skipped + 1))
      continue
    fi
    encode "$src" "$(out_name "$slug" "$kind" "$width")" "$width" "$kind"
    total=$((total + 1))
  done
done

echo
total_files=$((total * 2))    # avif + webp per encode
echo "Wrote ${total_files} files (${total} variants × 2 formats) to ${DST#$(pwd)/}/"
[ "$skipped" -gt 0 ] && echo "Skipped ${skipped} variant(s) — see SKIP lines above."
