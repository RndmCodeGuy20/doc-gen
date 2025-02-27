#!/bin/bash
set -e

# Enable dry run mode if DRY_RUN is set to "true"
DRY_RUN=${DRY_RUN:-false}

echo "Running entrypoint.sh (Dry Run: $DRY_RUN)"

# Fetch commit messages
API_URL="https://api.github.com/repos/$REPO/pulls/$PR_NUMBER/commits"
if [ "$DRY_RUN" = "true" ]; then
  echo "[Dry Run] Would fetch commits from: $API_URL"
  COMMIT_MESSAGES=$(curl -s $API_URL | jq -r '.[].commit.message' | tr '\n' '; ')
else
  COMMIT_MESSAGES=$(curl -s $API_URL | jq -r '.[].commit.message' | tr '\n' '; ')
fi

export GENAI_API_KEY=$GENAI_API_KEY

# Run Python script to generate release notes
# if [ "$DRY_RUN" = "true" ]; then
#   echo "[Dry Run] Would generate release notes with mock commit messages: $COMMIT_MESSAGES"
# else
  export COMMIT_MESSAGES
  .venv/bin/python3 main.py
# fi
