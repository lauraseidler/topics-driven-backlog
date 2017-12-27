#!/usr/bin/env bash

echo "$0: starting build"

echo "--------- sudo netstat -nlp | grep 5432"
sudo netstat -nlp | grep 5432

docker-compose up -d

if [ $? != 0 ]; then
    echo "ERROR: docker-compose up -d FAILED"
    exit 1
else
    echo "--------- docker exec -ti postgresql-dev netstat -nlp | grep 5432"
    docker-compose exec postgresql netstat -nlp | grep 5432

    echo "done building and starting image"
    docker ps

    echo "starting tests in docker image"
    docker-compose exec app .docker/wait-for-db.sh
    docker-compose exec app rake db:create RAILS_ENV=test
    docker-compose exec app rake db:migrate RAILS_ENV=test
    docker-compose exec app rake db:migrate:status RAILS_ENV=test
    docker-compose exec app rspec spec
    docker-compose exec app ./node_modules/.bin/jest
fi