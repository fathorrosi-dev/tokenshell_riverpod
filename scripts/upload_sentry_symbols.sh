#!/usr/bin/env bash
# upload_sentry_symbols.sh
#
# Uploads Flutter debug symbols (produced by --obfuscate --split-debug-info)
# to Sentry so that obfuscated stack traces in crash reports remain readable.
#
# Usage (local):
#   export SENTRY_AUTH_TOKEN=<your-token>
#   export SENTRY_ORG=<your-org-slug>
#   export SENTRY_PROJECT=<your-project-slug>
#   ./scripts/upload_sentry_symbols.sh
#
# Usage (CI — GitHub Actions example):
#   - name: Upload Sentry Symbols
#     env:
#       SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
#       SENTRY_ORG: ${{ secrets.SENTRY_ORG }}
#       SENTRY_PROJECT: ${{ secrets.SENTRY_PROJECT }}
#     run: ./scripts/upload_sentry_symbols.sh
#
# Run AFTER flutter build appbundle/ipa with --split-debug-info=./debug-info/
# Run BEFORE uploading the binary to Play Store / App Store.
#
# Added: 27 Jun 2026 (R-02, R-07 — production readiness audit)

set -euo pipefail

# ── Validation ────────────────────────────────────────────────────────────────

if [ -z "${SENTRY_AUTH_TOKEN:-}" ]; then
  echo "ERROR: SENTRY_AUTH_TOKEN is not set." >&2
  echo "       Set it as a CI secret or export it before running this script." >&2
  exit 1
fi

if [ -z "${SENTRY_ORG:-}" ]; then
  echo "ERROR: SENTRY_ORG is not set." >&2
  exit 1
fi

if [ -z "${SENTRY_PROJECT:-}" ]; then
  echo "ERROR: SENTRY_PROJECT is not set." >&2
  exit 1
fi

# ── Upload ────────────────────────────────────────────────────────────────────

ANDROID_DIR="./debug-info/android"
IOS_DIR="./debug-info/ios"

if [ -d "$ANDROID_DIR" ]; then
  echo "→ Uploading Android debug symbols from $ANDROID_DIR ..."
  sentry-cli upload-dif "$ANDROID_DIR" \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT"
  echo "✓ Android symbols uploaded."
else
  echo "⚠  $ANDROID_DIR not found — skipping Android upload."
  echo "   Run: flutter build appbundle --obfuscate --split-debug-info=./debug-info/android/"
fi

if [ -d "$IOS_DIR" ]; then
  echo "→ Uploading iOS debug symbols from $IOS_DIR ..."
  sentry-cli upload-dif "$IOS_DIR" \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT"
  echo "✓ iOS symbols uploaded."
else
  echo "⚠  $IOS_DIR not found — skipping iOS upload."
  echo "   Run: flutter build ipa --obfuscate --split-debug-info=./debug-info/ios/"
fi

echo ""
echo "Done. Verify in Sentry: Settings → Debug Files."
