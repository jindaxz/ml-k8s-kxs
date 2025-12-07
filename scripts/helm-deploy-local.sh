#!/bin/bash

# Deploy/upgrade the ai-forecast chart into a local cluster

set -euo pipefail

CHART_DIR="helm/ai-forecast"
HELM_BIN="${HELM_BIN:-helm}"
RELEASE_NAME="${RELEASE_NAME:-ai-forecast}"
NAMESPACE="${NAMESPACE:-ai-forecast}"
VALUES_FILE="$CHART_DIR/values.dev.yaml"
EXTRA_ARGS=()

usage() {
  cat <<'EOF'
Deploy or upgrade the ai-forecast Helm chart locally.

Usage:
  scripts/helm-deploy-local.sh [-f values.yaml] [-n namespace] [-r release] [extra helm args...]

Options:
  -f, --values     Override values file (default: helm/ai-forecast/values.dev.yaml)
  -n, --namespace  Namespace to deploy into (default: ai-forecast)
  -r, --release    Release name (default: ai-forecast)
  -h, --help       Show this message

Examples:
  scripts/helm-deploy-local.sh
  scripts/helm-deploy-local.sh -f helm/ai-forecast/values.prod.yaml --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--values)
      VALUES_FILE="$2"
      shift 2
      ;;
    -n|--namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    -r|--release)
      RELEASE_NAME="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

if ! command -v "$HELM_BIN" >/dev/null 2>&1; then
  echo "Helm CLI not found. Install Helm 3+ before deploying." >&2
  exit 1
fi

if [[ ! -d "$CHART_DIR" ]]; then
  echo "Chart directory $CHART_DIR not found." >&2
  exit 1
fi

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "Values file $VALUES_FILE not found." >&2
  exit 1
fi

echo "🚀 Deploying release=$RELEASE_NAME namespace=$NAMESPACE values=$VALUES_FILE"
"$HELM_BIN" upgrade --install "$RELEASE_NAME" "$CHART_DIR" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  -f "$VALUES_FILE" \
  "${EXTRA_ARGS[@]}"

echo ""
echo "✅ Deployment command complete."
echo "ℹ️  To monitor status: kubectl get pods -n $NAMESPACE"
echo "ℹ️  To port-forward: kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME 8080:8000"
