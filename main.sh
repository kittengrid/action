#!/usr/bin/env bash

response=$( \
  curl -XPOST http://localhost:3000/api/agents/register \
       --header 'Content-Type: application/json' \
       --header "Authorization: Bearer $KITTENGRID_API_KEY" \
       --data "{
          \"vcs_provider\": \"github\",
          \"vcs_id\": \"$1\"
        }"
)

# Poor mans jq
AGENT_TOKEN=$(echo $response | cut -f4 -d '"')

curl -XPUT http://localhost:3000/api/agents \
       --header 'Content-Type: application/json' \
       --header "Authorization: Bearer $AGENT_TOKEN" \
       --data "{ \"workflow_id\": \"$GITHUB_RUN_ID\" }"
