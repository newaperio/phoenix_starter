#!/usr/bin/env bash
set -euo pipefail

# Retrieve APP_NAME
source ../../bin/env.sh

# Get service networkConfiguration
AWSVPC_CONFIG=$(aws ecs describe-services --services "${APP_NAME}" --cluster "${APP_NAME}" | jq -c ".services[] | select( .serviceName | contains(\"$APP_NAME\") ) | .networkConfiguration.awsvpcConfiguration" | tr -d \" | tr ':' '=')

aws ecs run-task --cluster "${APP_NAME}" --task-definition "${APP_NAME}-seed" --network-configuration "awsvpcConfiguration=${AWSVPC_CONFIG}"
