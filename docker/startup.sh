#!/usr/bin/env bash
set -eo pipefail
echo "Topics Driven Backlog entrypoint"

cd /usr/src/app
exec "$@"