---
layout: page
title: Teil II - Wartung
permalink: "/part2-maintain/"
lang: de

---
## Tell II: Pflege Deine GitHub Pages Seite

Ein Nachteil des ganzen Vorgehens ist, dass man die generierten Seitendateien separat einchecken und auf den `site` Remote Branch hochladen muss. Außerdem löscht Jekyll bei jedem neuen Built die `.nojekyll`-Datei, sodass wir sie jedes Mal neu anlegen müssen. Das wird schnell mühsam.

Daher habe ich ein `deploy.sh` bash script (für MacOS, ggf. anzupassen) vorbereitet, welches

1. adds, checks in and pushes the source files to the `master` branch of your remote repository,
2. builds the site,
3. creates the `.nojekyll` file in the `_site` folder and
4. adds, checks in and pushed the site files to the `site` branch of your remote repository.

This is more or less the whole updating workflow, so you might also run these commands from the command line, if you do not want to use the script right from the beginning.

To execute the script, you need to set the user permissions before you run it.

    # Set execution permissions
    chmod u+x deploy.sh
    # Run the script
    ./deploy.sh

The script will ask for a commit message (defaults to "Updated site") and also for the [Jekyll environment](https://jekyllrb.com/docs/configuration/environments/) (defaults to `development`). You need to run it as `production`, if you for example want to include Google Analytics. Normally, GitHub Pages automatically sets the `production` environment, but as we build locally, we need to tell Jekyll ourselves.

```bash
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
source_directory="docs"

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

# Check 2: We need to be in the sources branch
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
if [ -z "$commit_message" ]
then
	commit_message=$default_commit_message
fi
echo "Using commit message: '$commit_message'"

# Get JEKYLL_ENV
jekyll_environment="development"
read -p "Do you want to build in production environment (default: no)? (y/n) " yn
case $yn in
	[yY] ) echo "Running in production environment";
		jekyll_environment="production";;
	[nN] ) echo "Running in development environment";;
	* ) echo "Running in development environment";;
esac

# Add, commit and push
git add -A
git commit -m "$commit_message"
git push

# Change to the source directory
if ! [ -z "$source_directory" ]
then
	cd "$source_directory"
	echo "Changed to $(pwd)"
fi

# Build the site
JEKYLL_ENV=$jekyll_environment bundle exec jekyll build

# Change to the _site folder
cd _site
echo "Changed to $(pwd)"

# Check 3: Check for site branch
if ! git status | grep -q "On branch $site_branch"
then
	echo "Check 3 Error: You need to be in the $site_branch branch of your repository - exiting - no site checked in"
	exit 1
else
	echo "Check 3 OK - running in $site_branch branch"
fi

# Create .nojekyll file
touch .nojekyll

# Add, commit and push site files
git add -A
git commit -m "$commit_message"
git push

# Done
echo "--- done ---"
```