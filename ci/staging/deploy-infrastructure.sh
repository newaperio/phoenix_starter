#!/usr/bin/env bash
set -euo pipefail

pushd ../../infrasturcture/staging
    if [ -f terraform.tfstate ]; then
        echo "  Error, terraform.tfstate file present"
        exit 1
    fi
    terraform init -upgrade
    terraform plan
    terraform apply -auto-approve
popd