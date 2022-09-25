#!/bin/bash

################################################################################
### Script to deploy the built _site folder to the remote site branch
###
### Make sure that you are authenticated with GitHub from the command line:
### https://docs.github.com/en/authentication
################################################################################

# Variables
sources_branch="master"
site_branch="site"
default_commit_message="Updated site"

# Sanity checks
all_is_fine=true

# Check 1: You have to run this script from the directory it resides in
if ! [[ -f ./deploy.sh ]]
then
	echo "Check 2 Error: You need to run this script from the directory deploy.sh resides in"
	all_is_fine=false
else
	echo "Check 1 OK - running in the right directory"
fi

# Check 2: You have to run this script from the directory it resides in
if ! git status | grep -q "On branch $sources_branch"
then
	echo "Check 2 Error: You need to be in the $sources_branch branch of your repository"
	all_is_fine=false
else
	echo "Check 2 OK - running in $sources_branch branch"
fi

# Evaluate checks
if ! $all_is_fine
then
	echo "Exiting - nothing checked in, nothing deployed"
	exit 1
fi

# Get commit message from the user
read -p "Enter a commit message (defaults to '$default_commit_message'): " commit_message
if [[ $commit_message='' ]]
then
	echo "Using default commit message: '$default_commit_message'"
	commit_message=$default_commit_message
fi

# Add, commit and push
git add -A
git commit -m "$commit_message"
git push
echo "Pushed sources to remote $sources_branch branch"
