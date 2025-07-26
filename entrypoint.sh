#!/bin/bash
set -e

rm -f tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

exec "$@"
