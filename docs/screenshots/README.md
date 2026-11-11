# Screenshots for submission

Save these PNGs in this folder:

| File | What to capture |
|---|---|
| `01-argocd-dashboard.png` | Applications page showing **demo-app-staging** and **demo-app-production** both *Synced / Healthy* |
| `02-staging-tree.png` | demo-app-staging resource tree (Deployment → ReplicaSet → 1 Pod) |
| `03-production-tree.png` | demo-app-production resource tree (3 Pods, HPA, PDB) |
| `04-ci-run.png` | App repo Actions run: test → build-and-push → update-config-repo all green |
| `05-config-commit.png` | Config repo commit `deploy(staging): demo-app sha-…` by gitops-bot |
| `06-production-outofsync.png` | demo-app-production OutOfSync after promotion PR merged, before Sync |
| `07-promote-approval.png` | Promote workflow waiting for `production` environment approval |
| `08-drift-selfheal.png` | Terminal output of `scripts/demo-drift.sh` showing 5 → 1 |
| `09-rollback.png` | ArgoCD history / `kubectl` showing the previous image after `git revert` |
| `10-rbac-denied.png` | dev-alice getting "permission denied" when syncing production |
