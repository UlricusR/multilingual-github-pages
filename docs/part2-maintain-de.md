---
layout: page
title: Teil II - Wartung
permalink: "/part2-maintain/"
lang: de
published: false

---
## Tell II: Aktualisiere Deine GitHub Pages Seite

Ein Nachteil des ganzen Vorgehens ist, dass man die generierten Seitendateien separat einchecken und auf den `site`-Remote-Branch hochladen muss. Außerdem löscht Jekyll bei jedem neuen Built die `.nojekyll`-Datei, sodass wir sie jedes Mal neu anlegen müssen. Das wird schnell mühsam.

Daher habe ich ein `deploy.sh`-Bash-Script (für MacOS, ggf. auf's eigene System anzupassen) vorbereitet, welches

1. die Quelldateien dem `master`-Branch hinzufügt, eincheckt und ins Remote-Repositoy hochlädt,
2. die Seitendateien erstellt,
3. die `.nojekyll`-Datei im `_site`-Ordner erstellt und
4. die Seitendateien dem `site`-Branch des Remote-Repositorys hinzufügt.

Dies ist mehr oder weniger der gesamte Aktualisierungs-Workflow. Du kannst die Kommandos natürlich auch einzeln in der Kommandozeile ausführen.

Um das Script ausführen zu können, musst Du die richtigen Benutzerrechte setzen:

    # Set execution permissions
    chmod u+x deploy.sh
    # Run the script
    ./deploy.sh

Das Script fragt nach einer Commit-Nachricht (Default: "Updated site") und auch nach dem [Jekyll environment](https://jekyllrb.com/docs/configuration/environments/) (Default: `development`). Du musst das Script im `production`-Environment laufen lassen, wenn Du z.B. Google Analytics nuten willst. Normalerweise setzt GitHub Pages automatisch das `production`-Environment, da wir aber lokal arbeiten, müssen wir es selbst setzen.

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