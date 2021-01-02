#!/usr/bin/env bash

set -e

source $(dirname $0)/utils.sh

print_header "Phoenix Starter"

if [ ! -f ".starter-version" ]; then
  print_error ".starter-version file not found"
  exit 1
fi

check_executable jq

current_version=$(/bin/cat .starter-version)
latest_version=$(
  curl \
    -s -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/newaperio/phoenix_starter/releases/latest |
    jq -r ".tag_name"
)

print_info "Current version" "$current_version"
print_info "Latest version" "$latest_version"

if [ $current_version == $latest_version ]; then
  print_success "Already at latest version!"
  exit
fi

print_info "Compare view" \
  "https://github.com/newaperio/phoenix_starter/compare/$current_version...$latest_version"
print_info "Changelog" \
  "https://github.com/newaperio/phoenix_starter/blob/$latest_version/CHANGELOG.md"
print_success "Make sure to update .starter-version after update"
