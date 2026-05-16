# Marketing-site dev targets. Run `make help` to see what's available.

APP_REPO ?= ../app.billederapport.dk
APP_FRAMED_DIR ?= $(APP_REPO)/sites/app/tests/screenshots/output-framed
APP_REPORT_PDF ?= $(APP_REPO)/sites/app/tests/screenshots/demo-report/output/Rottespaerre_servicekontrol_Sokrogvej_7.pdf

.PHONY: help import-screenshots import-report-pdf serve

help:
	@echo "Targets:"
	@echo "  make import-screenshots  Re-encode framed PNGs from the app repo into AVIF + WebP"
	@echo "                           variants under assets/screenshots/."
	@echo "                           Override source with APP_FRAMED_DIR=… or APP_REPO=…"
	@echo "  make import-report-pdf   Render the demo PDF report into AVIF + WebP page previews"
	@echo "                           and copy the source PDF into assets/report/."
	@echo "                           Override source with APP_REPORT_PDF=… or APP_REPO=…"
	@echo "  make serve               Serve the site at http://localhost:4000"

# Pull the latest framed screenshots from the sibling app repo and re-encode
# them as AVIF + WebP at the sizes the marketing site uses. Thin wrapper
# around scripts/import-screenshots.sh — see that script for the slug →
# source mapping and quality settings.
#
# Usage:
#   make import-screenshots
#   make import-screenshots APP_REPO=/path/to/app.billederapport.dk
#   make import-screenshots APP_FRAMED_DIR=/custom/output-framed
import-screenshots:
	@APP_FRAMED_DIR="$(APP_FRAMED_DIR)" scripts/import-screenshots.sh

# Render the demo PDF report from the app repo into AVIF + WebP page previews
# and copy the source PDF into assets/report/ for download. Thin wrapper
# around scripts/import-report-pdf.sh — see that script for page selection
# and quality settings.
#
# Usage:
#   make import-report-pdf
#   make import-report-pdf APP_REPO=/path/to/app.billederapport.dk
#   make import-report-pdf APP_REPORT_PDF=/custom/path/to.pdf
import-report-pdf:
	@APP_REPORT_PDF="$(APP_REPORT_PDF)" scripts/import-report-pdf.sh

# Local preview. Mirrors the command in CLAUDE.md so newcomers don't have to
# dig it out of the docs.
serve:
	@echo "→ http://localhost:4000"
	@python3 -m http.server 4000
