#!/usr/bin/env bash
AGENT_VERSION=0.0.8

for i in "$@"; do
    case $i in
    --repo)
        PROJECT_VCS_ID=$2
        shift 2
        ;;
    --pull-request)
        PULL_REQUEST_VCS_ID=$2
        shift 2
        ;;
    esac
done

if [ -z $PULL_REQUEST_VCS_ID ]; then
    echo "Missing argument: --pull-request-vcs-id"
    exit 1
fi

if [ -z $PROJECT_VCS_ID ]; then
    echo "Missing argument: --project-vcs-id"
    exit 1
fi

export KITTENGRID_VCS_PROVIDER="github"
export KITTENGRID_PROJECT_VCS_ID="$PROJECT_VCS_ID"
export KITTENGRID_PULL_REQUEST_VCS_ID="$PULL_REQUEST_VCS_ID"
export KITTENGRID_BIND_ADDRESS="0.0.0.0"
export KITTENGRID_WORKFLOW_RUN_ID=$GITHUB_RUN_ID
export KITTENGRID_SHOW_SERVICES_OUTPUT=true

if [ -z $KITTENGRID_API_URL ]; then
    export KITTENGRID_API_URL="https://app.kittengrid.com"
fi

if [[ "${GITHUB_TRIGGERING_ACTOR}" = *"[bot]" ]]; then
    export KITTENGRID_START_SERVICES=true
fi

env
mkdir -p /tmp/kittengrid/bin
rm -f /tmp/kittengrid/bin/kittengrid-agent

ARCH=$(uname -m)
case $ARCH in
x86_64)
    wget https://github.com/kittengrid/agent/releases/download/v${AGENT_VERSION}/kittengrid-agent-linux-amd64.tar.gz -O /tmp/kittengrid-agent.tar.gz
    ;;
arm64 | aarch64)
    wget https://github.com/kittengrid/agent/releases/download/v${AGENT_VERSION}/kittengrid-agent-linux-arm64.tar.gz -O /tmp/kittengrid-agent.tar.gz
    ;;
*)
    echo "Unsupported architecture: $ARCH"
    ;;
esac
tar xvzf /tmp/kittengrid-agent.tar.gz -C /tmp/
env >/tmp/vars
sudo -E bash -c "source /tmp/vars && /tmp/kittengrid-agent"
