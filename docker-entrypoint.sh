#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Check if the database exists, if not create it, then run migrations and seed the database.
bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
