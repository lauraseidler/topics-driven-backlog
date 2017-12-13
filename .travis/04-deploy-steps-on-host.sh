#!/usr/bin/env bash

exit_on_error () {
    sshexit=$1
    if [ $sshexit -eq 0 ]; then
        echo "step ok"
    else
        echo "ERROR: step failed with exit code $sshexit"
        echo "ERROR: deployment failed"
        exit $sshexit
    fi
}

echo "+++ pulling and starting docker containers"
docker-compose -f docker-compose.production.yml up -d
exit_on_error $?

echo "+++ Clean assets "
rm -rf nginx-assets
mkdir -p nginx-assets
echo "+++ copy packs from container to dir on host"
docker cp app:/usr/src/app/public/packs nginx-assets
exit_on_error $?

echo "+++ Wait for postgres"
docker-compose -f docker-compose.production.yml exec app .docker/wait-for-db.sh
exit_on_error $?

echo "+++ Database Migration"
docker-compose -f docker-compose.production.yml exec app bundle exec rake db:migrate
exit_on_error $?