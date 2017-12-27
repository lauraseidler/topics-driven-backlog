#!/usr/bin/env bash

echo "$0: starting build"

docker-compose up -d

if [ $? != 0 ]; then
    echo "ERROR: docker-compose up -d FAILED"
    exit 1
else
    echo "--------- docker-compose exec postgresql netstat -nlp | grep 5432"
    docker-compose exec postgresql netstat -nlp | grep 5432

    echo "done building and starting image"
    docker ps

    echo "starting tests in docker image"
    docker exec tdb-dev-app .docker/wait-for-db.sh
    docker exec tdb-dev-app rake db:create RAILS_ENV=test
    docker exec tdb-dev-app rake db:migrate RAILS_ENV=test
    docker exec tdb-dev-app rake db:migrate:status RAILS_ENV=test
    docker exec tdb-dev-app rspec spec
    docker exec tdb-dev-app ./node_modules/.bin/jest

    echo "uploading coverage reports"
    bash <(curl -s https://codecov.io/bash) -f coverage/.resultset.json -cF rails
    bash <(curl -s https://codecov.io/bash) -f test/__coverage__/coverage-final.json -cF javascript
fi