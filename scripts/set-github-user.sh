#!/usr/bin/env bash
# Replace the jason2303 placeholder with your GitHub username/org (lowercase).
# Usage: ./scripts/set-github-user.sh my-github-user
set -euo pipefail
USER_NAME="${1:?usage: $0 <github-username>}"
USER_NAME="$(echo "$USER_NAME" | tr '[:upper:]' '[:lower:]')"
cd "$(dirname "$0")/.."
grep -rl "jason2303" --exclude-dir=.git . | while read -r f; do
  sed -i.bak "s/jason2303/${USER_NAME}/g" "$f" && rm -f "$f.bak"
  echo "updated $f"
done
