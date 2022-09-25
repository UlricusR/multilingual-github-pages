#!/bin/bash

################################################################################
### Script to deploy the built _site folder to the remote site branch
###
### Make sure that you are authenticated with GitHub from the command line:
### https://docs.github.com/en/authentication
################################################################################

# Sanity checks
all_is_fine = true

# Check 1: You have to run this script from the directory it resides in
if ! [[ -f ./deploy.sh ]]; then
	echo "Error: You need to run this script from the directory deploy.sh resides in."
	all_is_fine = false
fi

# Check 2: You have to run this script from the directory it resides in
if ! [[ ./git status | grep -q 'On branch master' ]]; then
	echo "Error: You need to be in the master branch of your reäository."
	all_is_fine = false
fi

# Evaluate checks
if ! [[ $all_is_fine ]]; then
	exit 0
fi	