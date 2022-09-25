#!/bin/bash

################################################################################
### Script to deploy the built _site folder to the remote site branch
###
### Make sure that you are authenticated with GitHub from the command line:
### https://docs.github.com/en/authentication
################################################################################

# You have to run this script from the repository's base directory
if [[ -f ./deploy.sh ]]
then
    echo "deploy.sh exists on your filesystem."
fi
