#!/bin/bash
set -e

# Enable dry run mode if DRY_RUN is set to "true"
DRY_RUN=${DRY_RUN:-false}

echo "Running entrypoint.sh (Dry Run: $DRY_RUN)"

# Validate required environment variables
if [ -z "$REPO" ]; then
    echo "Error: REPO environment variable is not set"
    exit 1
fi

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR_NUMBER environment variable is not set"
    exit 1
fi

# Fetch commit messages
API_URL="https://api.github.com/repos/${REPO}/pulls/${PR_NUMBER}/commits"
echo "Fetching commits from: $API_URL"

if [ "$DRY_RUN" = "true" ]; then
    echo "[Dry Run] Would fetch commits from: $API_URL"
    COMMIT_MESSAGES="Mock commit message for dry run"
else
    # Add authentication header if GITHUB_TOKEN is provided
    if [ -n "$GITHUB_TOKEN" ]; then
        COMMIT_MESSAGES=$(curl -H "Authorization: token $GITHUB_TOKEN" -s "$API_URL" | jq -r '.[].commit.message' | tr '\n' '; ')
    else
        COMMIT_MESSAGES=$(curl -s "$API_URL" | jq -r '.[].commit.message' | tr '\n' '; ')
    fi
fi

if [ -z "$COMMIT_MESSAGES" ]; then
    echo "No commit messages found for PR #$PR_NUMBER"
    exit 1
else 
    echo "Found commit messages: $COMMIT_MESSAGES"
fi 

export GENAI_API_KEY=$GENAI_API_KEY
export COMMIT_MESSAGES

# Run Python script to generate release notes
python3 main.py
