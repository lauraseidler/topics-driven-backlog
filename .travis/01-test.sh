#!/usr/bin/env bash

echo "$0: starting build"

echo "--------- sudo netstat -nlp | grep 5432"
sudo netstat -nlp | grep 5432

docker-compose up -d

if [ $? != 0 ]; then
    echo "ERROR: docker-compose up -d FAILED"
    exit 1
else
    echo "--------- docker-compose exec postgresql netstat -nlp | grep 5432"
    docker-compose exec postgresql netstat -nlp | grep 5432

    echo "done building and starting image"


    echo "waiting for db"
    docker ps
    docker-compose config --services
    docker-compose exec app .docker/wait-for-db.sh

    echo "creating db"
    docker ps
    docker-compose config --services
    docker-compose exec app rake db:create RAILS_ENV=test

    echo "migrating db"
    docker ps
    docker-compose config --services
    docker-compose exec app rake db:migrate RAILS_ENV=test

    echo "db migration status"
    docker ps
    docker-compose config --services
    docker-compose exec app rake db:migrate:status RAILS_ENV=test

    echo "running rspec tests"
    docker ps
    docker-compose config --services
    docker-compose exec app rspec spec

    echo "running jest tests"
    docker ps
    docker-compose config --services
    docker-compose exec app ./node_modules/.bin/jest

    echo "uploading coverage reports"
    docker ps
    docker-compose config --services
    bash <(curl -s https://codecov.io/bash) -f coverage/.resultset.json -cF rails
    bash <(curl -s https://codecov.io/bash) -f test/__coverage__/coverage-final.json -cF javascript
fi