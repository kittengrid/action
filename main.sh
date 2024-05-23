#!/usr/bin/env bash

export KITTENGRID_API_KEY=$KITTENGRID_API_KEY
export KITTENGRID_API_URL="https://kittengrid.com"
export KITTENGRID_VCS_PROVIDER="github"
export KITTENGRID_VCS_ID="$1"
export KITTENGRID_BIND_ADDRESS="127.0.0.1"
export KITTENGRID_WORKFLOW_ID=$GITHUB_RUN_ID

mkdir -p /tmp/kittengrid/bin
wget https://releases.kittengrid.com/kittengrid-agent/0.0.1/kittengrid-agent_0.0.1_linux_amd64.zip -O /tmp/kittengrid-agent.zip
unzip /tmp/kittengrid-agent.zip -d /tmp/kittengrid/bin

sudo -E /tmp/kittengrid/bin/kittengrid-agent
