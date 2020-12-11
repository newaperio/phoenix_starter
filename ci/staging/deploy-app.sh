#!/usr/bin/env bash
set -euo pipefail

# Get terraform outputs
pushd ../../infrasturcture/staging
    REGION=$(terraform output region)
    ECR_URL=$(terraform output ecr_address)
    ECR_LOGIN_URL=$(echo "${ECR_URL}" | cut -d'/' -f1)
    CLUSTER_NAME=$(terraform output app)
    SERVICE_NAME=$(terraform output app)
popd

# Build, tag, and push docker container
pushd ../../
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_LOGIN_URL
    docker build -t local_image .
    docker tag local_image:latest $ECR_URL:latest
    docker push $ECR_URL:latest
popd

# Run new docker container in ECS
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --force-new-deployment