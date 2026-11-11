#!/usr/bin/env bash
# Creates the Slack webhook secret DIRECTLY in the cluster (never committed to Git).
# Usage: SLACK_WEBHOOK_URL=https://hooks.slack.com/services/XXX ./scripts/create-notification-secret.sh
set -euo pipefail
: "${SLACK_WEBHOOK_URL:?set SLACK_WEBHOOK_URL}"
kubectl -n argocd create secret generic argocd-notifications-secret \
  --from-literal=slack-webhook-url="${SLACK_WEBHOOK_URL}" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "argocd-notifications-secret created/updated"
