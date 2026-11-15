# Screenshots

| File | Shows |
|---|---|
| 01-ci-run | CI on push to main: lint + test, build + Trivy scan + push to GHCR, bump staging tag (all green) |
| 02-config-commit | gitops-bot commit `deploy(staging): demo-app sha-0bb42f0` in this repo (CI -> GitOps hand-off) |
| 03-staging-deployed | ArgoCD auto-deployed staging: app answers "Hello from GitOps v2", version sha-0bb42f0 |
| 04-promotion-pr | Promotion PR copying the staging tag into the production overlay |
| 05-rbac-dev-denied | dev-alice (developer) is denied syncing production (ArgoCD RBAC) |
| 06-production-diff | release-bob reviews the production diff before the manual sync |
| 07-argocd-both-synced | ArgoCD dashboard: demo-app-staging and demo-app-production both Synced |
