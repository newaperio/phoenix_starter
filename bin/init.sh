#!/usr/bin/env bash

set -e

print_step() {
  echo
  echo "==> $1"
}

print_success() {
  echo
  echo -e "\033[32m> Success:\033[0m $1"
}

print_error() {
  echo -e "\033[31m! Error:\033[0m $1"
}

print_usage() {
  echo
  echo "Usage: $(basename "$0") pascal snake"
  echo "  pascal: PascalCase version of new project name, ex: StormWeb"
  echo "  snake: snake_case version of new project name, ex: storm_web"
  echo
}

rename() {
  ack -l "$1" --ignore-file=is:init.sh --ignore-file=match:/[.]beam$/ | \
    xargs sed -i '' -e "s/$1/$2/g"
}

pascal_case_old="PhoenixStarter"
snake_case_old="phoenix_starter"
kebab_case_old="phoenix-starter"

pascal_case_new=$1
snake_case_new=$2
kebab_case_new=${snake_case_new/_/-}

if [[ ! -f "mix.lock" ]]; then
  print_error "Must be run from Phoenix root"
  exit 1
fi

if [[ -z $pascal_case_new ]]; then
  print_error "Missing \`pascal\` argument"
  print_usage
  exit 1
fi

if [[ -z $snake_case_new ]]; then
  print_error "Missing \`snake\` argument"
  print_usage
  exit 1
fi

echo -e "\033[47m\033[36m         < NewAperio >        \033[0m"
echo "Phoenix Starter Initialization"
echo "------------------------------"

print_step "Renaming files"
rename "$pascal_case_old" "$pascal_case_new"
rename "$snake_case_old" "$snake_case_new"
rename "$kebab_case_old" "$kebab_case_new"

mv lib/"$snake_case_old" lib/"$snake_case_new"
mv lib/"${snake_case_old}.ex" lib/"${snake_case_new}.ex"
mv lib/"${snake_case_old}_web" lib/"${snake_case_new}_web"
mv lib/"${snake_case_old}_web.ex" lib/"${snake_case_new}_web.ex"
mv test/"${snake_case_old}_web" test/"${snake_case_new}_web"

print_step "Copying blank README"
mv README_starter.md README.md

print_step "Removing starter specific files"
rm CHANGELOG.md
rm LICENSE

print_step "Removing this script"
rm bin/init.sh

print_success "Complete!"
