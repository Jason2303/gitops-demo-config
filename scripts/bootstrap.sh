#!/usr/bin/env bash
# One-time cluster bootstrap: kind cluster + ArgoCD + project/RBAC/notifications + ApplicationSet.
# After this, every change to the cluster goes through Git.
set -euo pipefail
cd "$(dirname "$0")/.."

CLUSTER="${CLUSTER:-gitops-demo}"
ARGOCD_VERSION="${ARGOCD_VERSION:-stable}"   # pin e.g. v3.1.0 for reproducibility

if grep -rq "YOUR_GH_USER" argocd apps; then
  echo "ERROR: run ./scripts/set-github-user.sh <your-github-user> first"; exit 1
fi

echo ">> Creating kind cluster '${CLUSTER}' (skipped if it exists)"
kind get clusters | grep -qx "${CLUSTER}" || kind create cluster --name "${CLUSTER}"

echo ">> Installing ArgoCD (${ARGOCD_VERSION})"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo ">> Waiting for ArgoCD components"
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
kubectl -n argocd rollout status deploy/argocd-applicationset-controller --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s

echo ">> Local demo accounts (use SSO in real life)"
kubectl -n argocd patch configmap argocd-cm --type merge \
  -p '{"data":{"accounts.dev-alice":"login","accounts.release-bob":"login"}}'

echo ">> RBAC, notifications, project, ApplicationSet"
kubectl apply -f argocd/rbac/argocd-rbac-cm.yaml
kubectl apply -f argocd/notifications/argocd-notifications-cm.yaml
kubectl apply -f argocd/projects/demo-project.yaml
kubectl apply -f argocd/applicationset/demo-app.yaml

echo
echo "ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
echo
echo "UI:  kubectl -n argocd port-forward svc/argocd-server 8080:443   ->  https://localhost:8080  (user: admin)"
echo "Apps: kubectl -n argocd get applications"
