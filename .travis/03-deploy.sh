#!/usr/bin/env bash

echo "$0: starting deployment"

export DEPLOYMENT_ENVIRONMENT=$1

echo "DEPLOYMENT_ENVIRONMENT: [${DEPLOYMENT_ENVIRONMENT}]"

if [ -z ${DEPLOYMENT_ENVIRONMENT} ]; then
    echo "ERROR: no deployment environment given"
    echo "usage: $0 <environment>"
    echo "end $0"
    exit 1
fi

. set-variables.sh
. echo-variables.sh

if [ ${DEPLOYMENT_SHOULD_RUN} != "true" ]; then
    echo "***** SKIPPING DEPLOYMENT: DEPLOYMENT_SHOULD_RUN $DEPLOYMENT_SHOULD_RUN *****"
    echo "end $0"
    exit 0
fi

. decrypt-keys.sh ${DEPLOYMENT_ENVIRONMENT}
. docker-deploy.sh

echo "end $0"