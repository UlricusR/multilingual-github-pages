# Building a Multi-Lingual GitHub Page with Unsupported Jekyll Plugins

*A step-by-step guide to build a multi-lingual website using Jekyll plugins not supported by GitHub Pages*

GitHub Pages offers great possibilities to host static, version controlled homepages. One downside is the support for only a [limited amount of Jekyll-plugins](https://pages.github.com/versions/). I was especially interested in using the [Polyglot plugin](https://github.com/untra/polyglot), because my website needed to be available in English and German.

As GitHub Pages does not support this specific plugin, I searched for workarounds. The most promising one I found in [Dani's Braindump blog](https://tiefenauer.github.io/blog/gh-pages-plugins/), which I will apply with some modifications. I will describe my experience in setting up a multi-language site in GitHub Pages in the following step-by-step guide.

You can also use this repository as a blueprint to start your own multi-lingual website. Just fork it and use the file structure as a template. However, do read the following steps carefully, as you'll need to understand how to set up and maintain your website.

## Assumptions and Pre-Requisites

- You have a GitHub account
- You have git installed on your computer and know how to apply its command line commands (I am working with MacOS terminal, but the git commands should be identical across all platforms)
- You are [authenticated with GitHub](https://docs.github.com/en/authentication) from your command line
- You know the difference between GitHub and git
- You have [Jekyll](https://jekyllrb.com) installed on your computer and are familiar with its basics

## Basic Idea and Procedure

The basic idea is to have one GitHub repository containing two branches, one hosting the source files used by Jekyll to build the site (I will use the default `master` branch for this and store the docs in a `/docs` subfolder), the other to host the readily built site (I will use a `site` branch for this).

You'll build the site locally, based on the files in the `master` branch, and then commit the finally built static site to the `site` branch, where they will be - once configured - automatically published by GitHub Pages' *build and deploy* workflow. You may also push these built files to any other webserver, but I'll focus on the GitHub Pages path in this guide.

## Part I: Create your GitHub Pages site

### Step 1: Create a new GitHub repository

Create a new GitHub repository. This will normally leave you with a `main` branch. Rename this to `master` and clone it to your computer (or keep it, but then replace all the `master` instructions below with `main`).

### Step 2: Create a folder for your sources

Navigate to your local repository (you're in the master branch) and create the `/docs` folder.

```
cd /path/to/your/repository
mkdir docs
cd docs
```

### Step 3: Create a new Jekyll site

We will use the created folder as publishing source and create a new Jekyll site there.

`jekyll new --skip-bundle .`

Open the gemfile that Jekyll created and add "#" to the beginning of the line that starts with `gem "jekyll"` to comment out this line. Then add the github-pages gem by editing the line starting with `# gem "github-pages"`. Change this line to:

`gem "github-pages", "~> GITHUB-PAGES-VERSION", group: :jekyll_plugins`

Replace *GITHUB-PAGES-VERSION* with the latest supported version of the `github-pages` gem. You can find this version here: "[Dependency versions.](https://pages.github.com/versions/)"

Save and close the gemfile and run `bundle install`.

As your GitHub Page will be hosted in a subdirectory (e.g. for this specific site: ulricusr.github.io/*multilingual-github-pages/*), you need to add the `baseurl` to the Jekyll `_config.yml` file in your `/docs` directory: `baseurl: <your repository name>`.

You can optionally preview your site on [http://localhost:4000/multilingual-github-pages](http://localhost:4000/multilingual-github-pages) after having run `bundle exec jekyll serve`.

Finally build your site using `bundle exec jekyll build`. This will create a `_site` folder, which should already be listed in your `.gitignore` file. If not, do so.

### Step 4: Commit your sources to your GitHub repository

To do so, move to the root directory of your local git repository, add and commit the newly created files (including the `/docs` folder and ignoring the `/docs/_site` folder), and push everything to your remote repository on GitHub.

```
cd ..
git add -A
git commit -m "Initial commit"
git push
```

Your source files should now be in your GitHub repository. It's time to take care of the generated site files.

### Step 5: Create a new local repository for your site files

Navigate to your `/docs/_site` folder and initialize a new repository with the same remote as above.

```
cd docs/_site/
git init .
git remote add origin https://github.com/<your-username>/<your-repo-name>
```

As we want our files to be pushed to a separate branch `site`, we need to create this branch using `git branch site`.

### Step 6: Prepare your site files and push them to your remote repository

Before we push our site files, we need to create one new, empty file named `.nojekyll`. It makes sure that GitHub Pages does not process the site files, but deploys them as they come.

`touch .nojekyll`

Now add, commit and push all site files to your remote repository. As the branch does not exist yet remotely, we need to set the upstream, using the `-u` option.

```
git add -A
git commit -m "Initial commit"
git push -u origin site
```

Your site files should now reside in the `site` branch in your GitHub repository.

### Step 7: Configure GitHub to the right publishing source

The final step is to configure GitHub Pages to deploy your site. Go to the settings of your repository, choose *Pages* from the menu, and set the build and deployment source to *Deploy from a branch*, then select your `site` branch and keep the `/(root)` folder. Hit save, wait a minute or so (you can always check the deployment progress in the "Actions" tab of your repository), and then check your online site by hitting the "Visit site" button.

![Configure your publishing source](/images/github_pages_config.png)

## Part II: Updating your GitHub Pages site

One downside of this whole approach is that you need to separately commit and push your generated site files to the remote `site` branch. In addition, as Jekyll's `bundle exec jekyll build` command will erase the `.nojekyll` file every time it runs, we have to make sure that we don't forget to add it before pushing. This can be cumbersome.

Therefore I have prepared the `deploy.sh` bash script (for MacOS - you might need to adapt if for other operating systems), which

1. adds, checks in and pushes the source files to the `master` branch of your remote repository,
2. builds the site,
3. creates the `.nojekyll` file in the `_site` folder and
4. adds, checks in and pushed the site files to the `site` branch of your remote repository.

This is more or less the whole updating workflow, so you might also run these commands from the command line, if you do not want to use the script right from the beginning.

To execute the script, you need to set the user permissions before you run it.

```
# Set execution permissions
chmod u+x deploy.sh
# Run the script
./deploy.sh
```

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

## Part III: Building the multi-lingual site

Let's now build our multilingual site using the [Polyglot plugin](https://github.com/untra/polyglot). The site is based on Jekyll's `minima` theme, so if you use another theme, the steps might look different in detail, but should be rather similar.

### Step 1: Install the plugin

Navigate to your publishing source directory `/docs` and add the following to your `Gemfile`:

```
group :jekyll_plugins do
   gem "jekyll-polyglot"
end
```

Alternatively, install the gem locally following the description in the Polyglot README. Then specify the plugin in your `_config.yml`:

```
plugins:
  - jekyll-polyglot
```

Run `bundle install` to finalize the installation.

### Step 2: Configure the plugin

Please refer to the Polyglot README for details on the configuration. For my purposes (English as default language, German as second language), the following configuration in `_config.yml` was sufficient:

```
# Polyglot language plugin settings
languages: ["en", "de"]
default_lang: "en"
exclude_from_localization: ["assets", "javascript", "images", "css", "public"]
parallel_localization: true
```

### Step 3: Localize your metadata

The site will use some metadata like the title or the description, which are stored in the `_config.yml` file. You need to add a language specific title and description:

```
title:
  en: Multi-lingual GitHub Page
  de: Mehrsprachige GitHub-Seite
description:
  en: A sample multi-lingual GitHub Page built with a Jekyll plugin not supported by GitHub Pages.
  de: Eine mehrsprachige Demoseite erstellt mit einem von GitHub Pages nicht unterstützten Jekyll-Plugin
```

The title is used in the `header.html` file of the `minima` theme. Therefore we need to override the remote `header.html` file by creating a `_includes` folder in the top level publishing folder (here: `docs`) and save a copy there. Next, we need to let Jekyll know which language we're in by adding the following line as first line in `header.html`, which creates the variable `lang` and assigns the current language:

```
{% assign lang = site.active_lang %}
<header class="site-header">
	...
```

Finally, we need to modify the line containing `{{ site.title | escape }}` with `{{ site.title[lang] | escape }}`.

The description is used in the `footer.html` file, so simply repeat the steps above, but replace `{{ site.description | escape }}` with `{{ site.description[lang] | escape }}`.

### Step 4: Localize your title tag

As a last step, we have to take care of the `<title>` tag in Jekyll's built-in SEO section, because the site description is also used there. The title tag is used by search engines, but also by most browsers to name the browser tab. As we cannot pass a custom title to Jekyll's SEO section, we need to disable the display of the title there and create our own `<title>` tag instead.

To do so, we need to override Minima's `head.html` (and along with it the `custom-head.html`, otherwise we'd run into an error when building the site). So copy those two files from Minima's `_includes` folder to your `_includes` folder and open `head.html` for editing (you can leave `custom-head.html` untouched, but may also use for further customizations like adding a favicon).

Modify the line `{%- seo -%}` to `{%- seo title=false -%}`.

> For some reason, which I didn't dig in deeper, overriding `head.html` lead to my site no longer finding the right stylesheet. I had to change the line `<link rel="stylesheet" href="{{ "/assets/css/style.css" | relative_url }}">` to `<link rel="stylesheet" href="{{ "/assets/main.css" | relative_url }}">` to fix it.

Finally, we'll have to add our own custom title in `head.html`. As very first line of the file, set the language by adding `{% assign lang = site.active_lang %}`.

Then add the following code before the modified `{%- seo title=false -%}` line:

```
<title>
	{% if page.title %}{{ page.title }} - {% endif %}
	{% if site.title[lang] %}{{ site.title[lang] }}{% endif %}
</title>
```

It will add the page title, if set in the frontmatter of the file, and then append the localized site title, separated by a dash.

### Step 5: Localize your main menu

Minima allows you to define the order of the top menu items by adding those to `_config.yml`. We need to do this for all languages:

```
# Top menu order
header_pages:
  en:
    - about-en.md
    - prerequisites-en.md
    - part1-setup-en.md
    - part2-maintain-en.md
    - part3-multilingual-en.md
  de:
    - about-de.md
    - prerequisites-de.md
    - part1-setup-de.md
    - part2-maintain-de.md
    - part3-multilingual-de.md
```

Next, in `header.html` change `{%- assign page_paths = site.header_pages | default: default_paths -%}` to `{%- assign page_paths = site.header_pages[lang] | default: default_paths -%}`.

### Step 6: Localize your pages

Pages are localized by adding one file per language and using the language code to extend the filename. With `en` being the default language and `de` the additional language for this example, we will need to have a `...-en.md` and a `...-de.md` version for each file we want to localize (also works with `html` files).

In addition, we need to add the identical `permalink` and a `lang` tag to the frontmatter of each file.

So, rename your `index.md` to `index-en.md` and add the following lines to the frontmatter:

```
---
layout: home
permalink: /
lang: en
---
```

Duplicate the file and save it as `index-de.md`. Translate the content and add the following lines to the frontmatter:

```
---
layout: home
permalink: /
lang: de
---
```

It is very important to have the permalink identical in all language files.

Repeat the same procedure for all your pages. My `about.md`, for example, becomes `about-en.md` and has the following frontmatter:

```
---
layout: page
title: About
permalink: /about/
lang: en
---
```

My `about-de.md` has the following frontmatter:

```
---
layout: page
title: Über
permalink: /about/
lang: de
---
```

### Step 7: Localize your posts

In the `_posts` folder, create a subfolder for each *additional* language (not the default language!). In my case, I only created a `docs/_posts/de` folder. Copy all posts, which you want translated, into that folder. If you leave a post away, the Polyglot plugin will use the default language post instead (see the `Welcome to Jekyll` post in my sample site for a demonstration of this feature).

Don't change the filename of the post in the language subfolder!

Finally, add the `lang` tag in the frontmatter of all posts (also those in the default language).

### Step 8: Add a language switcher

To enable the user to switch between languages, I added a language switcher in `header.html`. Add the following code before the closing `</header>` tag:

```html
<div class="wrapper">
	{% assign is_first_language = true %}
	<!-- jekyll-polyglot will process ferh= into href= through the static_href liquid block tag without relativizing the url; useful for making language navigation switchers  -->
	{% for tongue in site.languages %}
		{% if is_first_language == false %}|{% endif %}
		<a {% if tongue == site.active_lang %}style="font-weight: bold;"{% endif %} {% static_href %}href="{% if tongue == site.default_lang %}{{site.baseurl}}{{page.url}}{% else %}{{site.baseurl}}/{{ tongue }}{{page.url}}{% endif %}"{% endstatic_href %} >{{ tongue }}</a>
		{% assign is_first_language = false %}
	{% endfor %}
</div>
```

Deploy your site using the `deploy.sh` script and you should be good to go with your first multilingual Jekyll site.
