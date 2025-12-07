#!/bin/bash

# Package (and optionally push) the ai-forecast Helm chart

set -euo pipefail

CHART_DIR="helm/ai-forecast"
OUTPUT_DIR="dist/charts"
HELM_BIN="${HELM_BIN:-helm}"
PUSH_TARGET=""

usage() {
  cat <<'EOF'
Package the ai-forecast Helm chart.

Usage:
  scripts/helm-package.sh [--push <oci://registry/repo>]

Options:
  --push    Optional OCI/Git registry target (overrides HELM_REGISTRY env)
  -h, --help Show this help message

Environment variables:
  HELM_REGISTRY   Default registry when --push is omitted (e.g. oci://localhost:5000/helm)
  HELM_BIN        Helm binary to execute (default: helm)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --push)
      PUSH_TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! command -v "$HELM_BIN" >/dev/null 2>&1; then
  echo "Helm CLI not found. Install Helm 3+ before packaging." >&2
  exit 1
fi

TARGET_REGISTRY="${PUSH_TARGET:-${HELM_REGISTRY:-}}"

echo "📦 Linting chart..."
"$HELM_BIN" lint "$CHART_DIR"

echo "🗂️  Packaging chart into $OUTPUT_DIR..."
mkdir -p "$OUTPUT_DIR"
PACKAGE_OUTPUT=$("$HELM_BIN" package "$CHART_DIR" --destination "$OUTPUT_DIR")
echo "$PACKAGE_OUTPUT"

PACKAGE_FILE=$(echo "$PACKAGE_OUTPUT" | awk '/Saved it to:/ {print $NF}')
if [[ -z "${PACKAGE_FILE:-}" || ! -f "$PACKAGE_FILE" ]]; then
  PACKAGE_FILE=$(ls -t "$OUTPUT_DIR"/ai-forecast-*.tgz 2>/dev/null | head -n 1)
fi

if [[ -z "${PACKAGE_FILE:-}" || ! -f "$PACKAGE_FILE" ]]; then
  echo "Failed to locate packaged chart artifact in $OUTPUT_DIR" >&2
  exit 1
fi

echo "✅ Chart packaged: $PACKAGE_FILE"

if [[ -n "$TARGET_REGISTRY" ]]; then
  echo "🚢 Pushing chart to $TARGET_REGISTRY ..."
  "$HELM_BIN" push "$PACKAGE_FILE" "$TARGET_REGISTRY"
  echo "✅ Push complete."
else
  echo "ℹ️  Skipping push (set --push or HELM_REGISTRY to enable)."
fi
