#!/usr/bin/env bash
# Replace the YOUR_GH_USER placeholder with your GitHub username/org (lowercase).
# Usage: ./scripts/set-github-user.sh my-github-user
set -euo pipefail
USER_NAME="${1:?usage: $0 <github-username>}"
USER_NAME="$(echo "$USER_NAME" | tr '[:upper:]' '[:lower:]')"
cd "$(dirname "$0")/.."
grep -rl "YOUR_GH_USER" --exclude-dir=.git . | while read -r f; do
  sed -i.bak "s/YOUR_GH_USER/${USER_NAME}/g" "$f" && rm -f "$f.bak"
  echo "updated $f"
done
