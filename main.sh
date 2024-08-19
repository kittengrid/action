#!/usr/bin/env bash

for i in "$@"; do
  case $i in
    --repo)
      PROJECT_VCS_ID=$2
      shift 2
      ;;
    --pull-request)
      PULL_REQUEST_VCS_ID=$2
      shift 2
  esac
done

if [ -z $PULL_REQUEST_VCS_ID ]; then
  echo "Missing argument: --pull-request-vcs-id"
  exit 1;
fi

if [ -z $PROJECT_VCS_ID ]; then
  echo "Missing argument: --project-vcs-id"
  exit 1;
fi

export KITTENGRID_VCS_PROVIDER="github"
export KITTENGRID_PROJECT_VCS_ID="$PROJECT_VCS_ID"
export KITTENGRID_PULL_REQUEST_VCS_ID="$PULL_REQUEST_VCS_ID"
export KITTENGRID_BIND_ADDRESS="0.0.0.0"
export KITTENGRID_WORKFLOW_ID=$GITHUB_RUN_ID

if [ -z $KITTENGRID_API_URL ]; then
  export KITTENGRID_API_URL="https://kittengrid.com"
fi

mkdir -p /tmp/kittengrid/bin
wget https://releases.kittengrid.com/kittengrid-agent/0.0.1/kittengrid-agent_0.0.1_linux_amd64.zip -O /tmp/kittengrid-agent.zip
unzip /tmp/kittengrid-agent.zip -d /tmp/kittengrid/bin

sudo -E /tmp/kittengrid/bin/kittengrid-agent
