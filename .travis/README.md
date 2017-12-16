# Automatic deploy with TravisCI and Docker

When a branch is merged into the `develop` branch, TravisCI will automatically take the following steps to ensure deployment to the HTW stage server:

## Build and push docker image
Travis will build the image from Dockerfile.production, and push it to Docker Hub.

## Deploy
Travis will update the necessary files which are NOT part of the docker image (e.g. docker-compose.yml) to the remote host.

## Deploy steps on host
After copying the necessary files, Travis will call the script to update the environment on the host.

## TODO explanations
- crontab
- ssh keys + travis encryption
- differences Dockerfile + docker-compose in production