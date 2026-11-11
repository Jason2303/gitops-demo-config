#!/usr/bin/env bash
# Demonstrates rollback = git revert in the config repo.
# Usage: ./scripts/demo-rollback.sh [staging|production]
set -euo pipefail
cd "$(dirname "$0")/.."
ENV="${1:-staging}"
FILE="apps/demo-app/overlays/${ENV}/kustomization.yaml"

git pull --rebase origin main
LAST=$(git log -1 --format=%H -- "$FILE")
echo ">> Last change to ${ENV}:"
git log -1 --format='   %h %s (%an, %ar)' "$LAST"
echo ">> Current tag: $(yq '.images[0].newTag' "$FILE")"

git revert --no-edit "$LAST"
echo ">> Tag after revert: $(yq '.images[0].newTag' "$FILE")"
git push origin main

if [ "$ENV" = "staging" ]; then
  echo ">> Staging auto-syncs. Force an immediate refresh instead of waiting for the 3-min poll:"
  echo "   argocd app get demo-app-staging --refresh"
else
  echo ">> Production is manual: open ArgoCD and Sync demo-app-production (release-manager role),"
  echo "   or: argocd app sync demo-app-production"
fi
echo ">> Verify: kubectl -n demo-${ENV} get deploy demo-app -o jsonpath='{.spec.template.spec.containers[0].image}'"
