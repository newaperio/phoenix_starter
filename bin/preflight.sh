#!/usr/bin/env bash

set -e

check_failed=0

check_executable() {
  if ! [ -x "$(command -v "$1")" ]; then
    print_error "Could not find \`$1\` exec"
    check_failed=$((check_failed + 1))
  fi
}

print_step() {
  echo
  echo "==> $1"
}

print_error() {
  echo -e "\033[31m! Error:\033[0m $1"
}

print_success() {
  echo -e "\033[32m> Success:\033[0m $1"
}

print_step "Checking prerequisites"

check_executable autoconf # Erlang prereq
check_executable gpg # Node prereq
check_executable asdf
check_executable docker
check_executable psql

if [[ $check_failed = 0 ]]; then
  print_success "All prerequisites installed"

  print_step "Installing asdf plugins..."
  asdf plugin-add erlang
  asdf plugin-add elixir
  asdf plugin-add nodejs

  print_step "Running asdf..."
  asdf install

  print_success "Preflight finished"
else
  exit 1
fi
