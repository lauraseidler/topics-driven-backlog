#!/usr/bin/env bash

# If database exists, migrate. Otherweise create and seed
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:setup
echo "Done!"