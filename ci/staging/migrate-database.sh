#!/usr/bin/env bash
set -euo pipefail

APP_NAME="phoenix-starter"

# Get service networkConfiguration
AWSVPC_CONFIG=$(aws ecs describe-services --services "${APP_NAME}" --cluster "${APP_NAME}" | jq -c ".services[] | select( .serviceName | contains(\"$APP_NAME\") ) | .networkConfiguration.awsvpcConfiguration" | tr -d \" | tr ':' '=')

aws ecs run-task --cluster "${APP_NAME}" --task-definition phoenix-starter-migrate --network-configuration "awsvpcConfiguration=${AWSVPC_CONFIG}"