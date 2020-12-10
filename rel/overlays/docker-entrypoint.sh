#!/usr/bin/env bash

set -e

case $1 in
  migrate | migrations | rollback)
    /opt/app/bin/phoenix_starter eval "PhoenixStarter.ReleaseTasks.$1" "${@:2}"
    ;;

  *)
    eval /opt/app/bin/phoenix_starter "$@"
    ;;
esac
