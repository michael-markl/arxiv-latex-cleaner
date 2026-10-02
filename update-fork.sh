#!/usr/bin/bash

set -euo pipefail

CHERRY_PICKS=(
    # FROM BRANCH main
    "1aeea20f11671ec0eadf2be49b27e409bac05284"
    "1691053dcdf8c6f1560a3e6c91aa896e26054562"
    "510d3d80ad7ff6fd99843b96034bc93fa059e22f"
    "60b5f0724d6bcf9fb251ec2a08acd1b0af0fbe8a"
    # FROM BRANCH fix-comment-removal
    "76445661fb313c7d1ba88ba7ca278cbd2f4b30fb"
    "b844e99f65723bf6c168c222795dd9bc449739ec"
)

# Include the script's commit before switching away from the current branch.
SCRIPT_COMMIT=$(git log -1 --format=%H -- update-fork.sh)
CHERRY_PICKS+=("$SCRIPT_COMMIT")

# Fetch the latest upstream main and use it as the base of a new branch.
git fetch upstream refs/heads/main:refs/remotes/upstream/main
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Error: commit or stash all changes, including untracked files, first." >&2
    exit 1
fi
git checkout soft-fork
git branch "soft-fork-backup"
git reset --hard upstream/main

git cherry-pick "${CHERRY_PICKS[@]}"
