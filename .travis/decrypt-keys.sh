#!/usr/bin/env bash

if [ -z ${TRAVIS} ]; then
  echo "$0: TRAVIS not set, skipping"
  exit 0
fi

if [ ${TRAVIS} == "true" ]; then
    echo "$0: decrypting ssh keys"
    openssl aes-256-cbc -K ${encrypted_fb365c1216b5_key} -iv ${encrypted_fb365c1216b5_iv} -in .travis/ssh_keys.tar.enc -out ssh_keys.tar -d
    tar xvf ssh_keys.tar
    chmod 0600 id_rsa*
    echo $1

    if [ -z $1 ]; then
        echo "usage: $0 [staging|production]"
        exit 0
    fi

    if [ $1 == "staging" ]; then
        echo "trying to ssh to staging"
        ssh -i id_rsa_staging deployer@backlog-staging.f4.htw-berlin.de "pwd  ; exit"
#    elif [ $1 == "production" ]; then
#        echo "trying to ssh to production"
#        ssh  -i id_rsa_production deployer@backlog-production.f4.htw-berlin.de "pwd ; exit"
    else
        echo "usage: $0 [staging|production]"
    fi
else
  echo "$0: TRAVIS not set, skipping"
fi