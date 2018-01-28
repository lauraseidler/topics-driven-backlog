#!/usr/bin/env bash

echo "$0: starting docker deploy"

echo "DEPLOYMENT_ENVIRONMENT: $DEPLOYMENT_ENVIRONMENT"
echo "DEPLOYMENT_TAG: $DEPLOYMENT_TAG"
echo "Deploying image for environment: $DEPLOYMENT_ENVIRONMENT with tag $DEPLOYMENT_TAG"

exit_on_error () {
    sshexit=$1
    if [ ${sshexit} -eq 0 ]; then
        echo "step ok"
    else
        echo "ERROR: step failed with exit code $sshexit"
        echo "ERROR: deployment failed"
        exit ${sshexit}
    fi
}

echo "copying docker-compose files to $DEPLOYMENT_HOST"
scp -i id_rsa_${DEPLOYMENT_ENVIRONMENT} .docker/variables.production.env ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST}:~
scp -i id_rsa_${DEPLOYMENT_ENVIRONMENT} .docker/docker-compose.production.yml ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST}:~
exit_on_error $?

echo "copying 04-deploy-steps-on-host.sh to server"
scp -i id_rsa_${DEPLOYMENT_ENVIRONMENT} .travis/04-deploy-steps-on-host.sh ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST}:~
exit_on_error $?

echo "sshing to $DEPLOYMENT_HOST and calling docker-compose"
# yes, these variables are meant to expand on the client side.
setEnvVarsString="export set TAG=$DEPLOYMENT_TAG; "
setEnvVarsString+="export set SECRET_KEY_BASE=$SECRET_KEY_BASE; "
setEnvVarsString+="export set LDAP_HTW_HOST=$LDAP_HOST; "
setEnvVarsString+="export set LDAP_HTW_PORT=$LDAP_PORT; "
setEnvVarsString+="export set LDAP_HTW_CONNECTSTRING=$LDAP_CONNECTSTRING;"
ssh -i id_rsa_${DEPLOYMENT_ENVIRONMENT} ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST} "$setEnvVarsString . ./04-deploy-steps-on-host.sh"
exit_on_error $?

# copy and activate cronjob file to remove old docker stuff
echo "copying crontab file file to $DEPLOYMENT_HOST"
scp -i id_rsa_${DEPLOYMENT_ENVIRONMENT} .travis/crontab ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST}:~
echo "sshing to $DEPLOYMENT_HOST and create the crontab"
ssh -i id_rsa_${DEPLOYMENT_ENVIRONMENT} ${DEPLOYMENT_USER}@${DEPLOYMENT_HOST} "cat crontab | crontab - ; rm crontab"

echo "Deployment successful"
echo "end $0"