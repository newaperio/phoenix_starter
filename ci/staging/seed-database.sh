#!/usr/bin/env bash
set -euo pipefail

# Retrieve APP_NAME
source ../../bin/env.sh

# Get service networkConfiguration
AWSVPC_SUBNETS=$(aws ecs describe-services --services "${APP_NAME}" --cluster "${APP_NAME}" | jq -c ".services[] | select( .serviceName | contains(\"$APP_NAME\") ) | .networkConfiguration.awsvpcConfiguration.subnets" | tr -d \")

pushd ../../infrastructure/staging
  AWSVPC_SECURITY_GROUP=$(terraform output task_security_group)
popd

AWSVPC_CONFIG="awsvpcConfiguration={subnets=${AWSVPC_SUBNETS},securityGroups=[${AWSVPC_SECURITY_GROUP}],assignPublicIp=DISABLED}"

aws ecs run-task --cluster "${APP_NAME}" --task-definition "${APP_NAME}-seed" --network-configuration "${AWSVPC_CONFIG}"
