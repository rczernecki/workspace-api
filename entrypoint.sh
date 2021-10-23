#!/bin/bash
set -e
if [ -f /usr/src/app/tmp/pids/server.pid ]; then
  rm -f /usr/src/app/tmp/pids/server.pid
fi
export RAILS_ENV=production
rails db:migrate
exec "$@"