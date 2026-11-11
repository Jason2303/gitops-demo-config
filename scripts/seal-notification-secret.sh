#!/usr/bin/env bash
# Bonus: Sealed Secrets. Encrypts the Slack webhook with the cluster's public key so the
# resulting SealedSecret is SAFE to commit. Only the in-cluster controller can decrypt it.
#
# Prereqs (one-time):
#   helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
#   helm install sealed-secrets sealed-secrets/sealed-secrets -n kube-system
#   install the `kubeseal` CLI
#
# Usage: SLACK_WEBHOOK_URL=https://hooks.slack.com/services/XXX ./scripts/seal-notification-secret.sh
set -euo pipefail
cd "$(dirname "$0")/.."
: "${SLACK_WEBHOOK_URL:?set SLACK_WEBHOOK_URL}"
kubectl -n argocd create secret generic argocd-notifications-secret \
  --from-literal=slack-webhook-url="${SLACK_WEBHOOK_URL}" \
  --dry-run=client -o yaml \
| kubeseal --controller-namespace kube-system --controller-name sealed-secrets --format yaml \
> argocd/notifications/sealed-notifications-secret.yaml
echo "Wrote argocd/notifications/sealed-notifications-secret.yaml (safe to commit)."
echo "Apply: kubectl apply -f argocd/notifications/sealed-notifications-secret.yaml"
