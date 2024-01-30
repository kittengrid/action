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

echo "---response---"
echo $response
echo "--------------"
