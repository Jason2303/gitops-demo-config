# Standalone Application manifests (alternative to the ApplicationSet)

These two files produce exactly what `argocd/applicationset/demo-app.yaml` generates.
They exist for reference / for clusters without the ApplicationSet controller.

**Apply EITHER the ApplicationSet OR these two files, never both** (they would fight over the same Application names).
