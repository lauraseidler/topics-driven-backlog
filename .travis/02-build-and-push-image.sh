#!/usr/bin/env bash

echo "$0: building docker image"

export DEPLOYMENT_ENVIRONMENT=staging

. ./set-variables.sh
. ./echo-variables.sh

if [ ${DEPLOYMENT_SHOULD_RUN} != "true" ]; then
  echo "***** SKIPPING BUILD AND PUSH: DEPLOYMENT_SHOULD_RUN $DEPLOYMENT_SHOULD_RUN *****"
  echo "end $0"
  exit 0
fi


docker build -f Dockerfile.production -t topicsdrivenbacklog/topicsdrivenbacklog:${DEPLOYMENT_TAG} .
return_code=$?

if [ ${return_code} != 0 ]; then
  echo "FAILED: docker build"
  exit ${return_code}
fi

docker images
echo "pushing image with tag topicsdrivenbacklog/topicsdrivenbacklog:$DEPLOYMENT_TAG"

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker push topicsdrivenbacklog/topicsdrivenbacklog:${DEPLOYMENT_TAG}
return_code=$?

if [ ${return_code} != 0 ]; then
  echo "FAILED: docker push"
  exit ${return_code}
fi

echo "end $0"