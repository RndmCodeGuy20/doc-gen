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
  COMMIT_MESSAGES=$(curl -s -H "Authorization: token $GITHUB_TOKEN" $API_URL | jq -r '.[].commit.message' | tr '\n' '; ')
fi

export OPENAI_API_KEY="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"
export GENAI_API_KEY="AIzaSyBx7gXn-sX8oDVWdpORBXsMrXZ9DngSgg0"

# Run Python script to generate release notes
# if [ "$DRY_RUN" = "true" ]; then
#   echo "[Dry Run] Would generate release notes with mock commit messages: $COMMIT_MESSAGES"
# else
  export COMMIT_MESSAGES
  .venv/bin/python3 main.py
# fi
