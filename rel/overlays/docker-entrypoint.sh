#!/usr/bin/env bash

set -e

case $1 in
  migrate)
    /opt/app/bin/phoenix_starter eval "PhoenixStarter.ReleaseTasks.$1"
    ;;

  migrations | seeds)
    /opt/app/bin/phoenix_starter eval "PhoenixStarter.ReleaseTasks.$1($2)"
    ;;

  rollback)
    /opt/app/bin/phoenix_starter eval "PhoenixStarter.ReleaseTasks.$1($2, $3)"
    ;;

  *)
    eval /opt/app/bin/phoenix_starter "$@"
    ;;
esac
