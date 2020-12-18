#!/usr/bin/env bash

print_header() {
  echo
  echo -e "\033[36m== $1 ==\033[m"
}

print_step() {
  echo
  echo "==> $1"
}

print_info() {
  echo -e "\033[9;38;5;93m$1: \033[m $2"
}

print_success() {
  echo -e "\033[32m> Success:\033[0m $1"
}

print_error() {
  echo -e "\033[31m! Error:\033[0m $1"
}

check_executable() {
  if ! [ -x "$(command -v "$1")" ]; then
    print_error "Could not find \`$1\` exec"
    exit 1
  fi
}
