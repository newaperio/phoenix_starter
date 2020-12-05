#!/usr/bin/env bash

config_path=${1:-/opt/app/env.json}

aws ssm get-parameters-by-path --path "/${APP_ENV}/${APP_NAME}" \
  --recursive \
  --with-decryption \
  --query "Parameters[]" \
  > "$config_path"

eval "$2"
