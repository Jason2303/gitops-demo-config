#!/usr/bin/env bash
# Demonstrates drift detection + self-heal on STAGING.
# A human "fixes" something with kubectl; ArgoCD puts it back to what Git says.
set -euo pipefail
NS=demo-staging

echo ">> Desired state from Git: 1 replica"
kubectl -n "$NS" get deploy demo-app

echo ">> Simulating a manual change: kubectl scale --replicas=5"
kubectl -n "$NS" scale deploy demo-app --replicas=5
kubectl -n "$NS" get deploy demo-app

echo ">> Watching ArgoCD revert it (Ctrl-C to stop)..."
for i in $(seq 1 12); do
  sleep 5
  echo "t+$((i*5))s  replicas(spec)=$(kubectl -n "$NS" get deploy demo-app -o jsonpath='{.spec.replicas}')  \
app-status=$(kubectl -n argocd get application demo-app-staging -o jsonpath='{.status.sync.status}/{.status.health.status}')"
done

echo
echo ">> Same test on PRODUCTION (no self-heal): change is reported as OutOfSync, not reverted."
echo "   kubectl -n demo-production set env deploy/demo-app DRIFT=yes"
echo "   kubectl -n argocd get application demo-app-production   # -> OutOfSync"
echo "   Then sync from the UI (release-bob) to restore Git state."
