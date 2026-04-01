#!/usr/bin/env bash
set -euo pipefail

cd /workspace

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

export RAILS_ENV="${RAILS_ENV:-development}"
export PORT="${PORT:-3000}"

if [ -f Procfile.dev ]; then
  exec bundle exec foreman start -f Procfile.dev
else
  exec bundle exec rails server -b 0.0.0.0 -p "${PORT}"
fi
