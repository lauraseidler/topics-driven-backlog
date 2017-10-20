#!/usr/bin/env bash
set -eo pipefail
echo "Topics Driven Backlog entrypoint"

"/docker/wait-for-db.sh"
"/docker/prepare-db.sh"

cd /usr/src/app
exec "$@"