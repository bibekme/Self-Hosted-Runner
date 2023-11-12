#!/bin/bash
  
ACCESS_TOKEN=$ACCESS_TOKEN
REPO=$GITHUB_REPO
OWNER=$REPO_OWNER
HOSTNAME=$(hostname)

AUTH_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/runner/actions-runner

./config.sh --url https://github.com/${OWNER}/${REPO} --token ${AUTH_TOKEN} --labels self-hosted,Linux,X64,${HOSTNAME}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${AUTH_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!