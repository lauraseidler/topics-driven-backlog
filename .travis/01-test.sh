#!/usr/bin/env bash

echo "$0: starting build"

echo "--------- sudo netstat -nlp | grep 5432"
sudo netstat -nlp | grep 5432

docker-compose up -d

if [ $? != 0 ]; then
    echo "ERROR: docker-compose up -d FAILED"
    exit 1
else
    echo "--------- docker exec -ti tdb-dev-postgres netstat -nlp | grep 5432"
    docker exec -ti tdb-dev-postgres netstat -nlp | grep 5432

    echo "done building and starting image"
    docker ps

    echo "starting tests in docker image"
    docker exec -ti tdb-dev-app .docker/wait-for-db.sh
    docker exec -e RAILS_ENV=test -ti tdb-dev-app rake db:create RAILS_ENV=test
    docker exec -e RAILS_ENV=test -ti tdb-dev-app rake db:migrate RAILS_ENV=test
    docker exec -e RAILS_ENV=test -ti tdb-dev-app rake db:migrate:status RAILS_ENV=test
    docker exec -e RAILS_ENV=test -ti tdb-dev-app rspec spec
    docker exec -e RAILS_ENV=test -ti tdb-dev-app ./node_modules/.bin/jest

    echo "uploading coverage reports"
    bash <(curl -s https://codecov.io/bash) -f coverage/.resultset.json -cF rails
    bash <(curl -s https://codecov.io/bash) -f test/__coverage__/coverage-final.json -cF javascript
fi