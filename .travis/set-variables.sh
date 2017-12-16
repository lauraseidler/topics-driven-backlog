#!/usr/bin/env bash

echo "DEPLOYMENT: starting deployment checks"
export set DEPLOYMENT_SHOULD_RUN=false

# check if application environment is set correctly
if [ ${APPLICATION_ENVIRONMENT} != "docker" ]; then
    echo "DEPLOYMENT: APPLICATION_ENVIRONMENT is set to ${APPLICATION_ENVIRONMENT}, skipping deployment"
else
    export set DEPLOYMENT_SHOULD_RUN=true
fi

# set deployment tag if not set
if [ -z ${TRAVIS_TAG} ]; then
  export set DEPLOYMENT_TAG=$(echo ${TRAVIS_COMMIT} | head -c 7)
else
  export set DEPLOYMENT_TAG=${TRAVIS_TAG}
fi

# set deploy user
export set DEPLOYMENT_USER=deployer

# set deploy host
if [ ${DEPLOYMENT_ENVIRONMENT} == "staging" ]; then
    export DEPLOYMENT_HOST="backlog-staging.f4.htw-berlin.de"
#elif [ ${DEPLOYMENT_ENVIRONMENT} == "production" ]; then
#    export DEPLOYMENT_HOST="backlog-production.f4.htw-berlin.de"
fi