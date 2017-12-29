#!/usr/bin/env bash

echo "$0: starting build"

echo "--------- sudo netstat -nlp | grep 5432"
sudo netstat -nlp | grep 5432

docker-compose -f docker-compose.yml -f .docker/docker-compose.test.yml up -d

if [ $? != 0 ]; then
    echo "ERROR: docker-compose up -d FAILED"
    exit 1
else
    echo "--------- docker-compose exec postgresql netstat -nlp | grep 5432"
    docker-compose exec postgresql netstat -nlp | grep 5432

    echo "done building and starting image"


    echo "waiting for db"
    docker-compose exec app .docker/wait-for-db.sh

    echo "creating db"
    docker-compose exec app rake db:create RAILS_ENV=test

    echo "migrating db"
    docker-compose exec app rake db:migrate RAILS_ENV=test

    echo "db migration status"
    docker-compose exec app rake db:migrate:status RAILS_ENV=test

    echo "running rspec tests"
    docker-compose exec app rspec spec

    echo "running jest tests"
    docker-compose exec app ./node_modules/jest-cli/bin/jest.js

    echo "uploading coverage reports"
    curl -s https://codecov.io/bash | bash -s -
fi