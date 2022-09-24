# Building a Multi-Lingual GitHub Page with Unsupported Jekyll Plugins

*A step-by-step guide to build a multi-lingual website using Jekyll plugins not supported by GitHub Pages*

GitHub Pages offers great possibilities to host static, version controlled homepages. One downside is the support for only a [limited amount of Jekyll-plugins](https://pages.github.com/versions/). I was especially interested in using the [jekyll-multiple-language-plugin](https://github.com/kurtsson/jekyll-multiple-languages-plugin), because my website needed to be available in English and German.

As GitHub Pages does not support this specific plugin, I searched for workarounds. The most promising one I found in [Dani's Braindump blog](https://tiefenauer.github.io/blog/gh-pages-plugins/), which I will apply with some modifications. I will describe my experience in setting up a multi-language site in GitHub Pages in the following step-by-step guide.

You can also use this repository as a blueprint to start your own multi-lingual website. Just fork it and use the file structure as a template. However, do read the following steps carefully, as you'll need to understand how to set up and maintain your website.

## Assumptions and Pre-Requisites

- You have a valid GitHub account
- You have git installed on your computer and know how to apply its command line commands (I am working with MacOS terminal, but the git commands should be identical across all platforms)
- You know the difference between GitHub and git
- You have [Jekyll](https://jekyllrb.com) installed on your computer and are familiar with its basics

## Basic Idea and Procedure

The basic idea is to have one GitHub repository containing two branches, one hosting the source files used by Jekyll to build the site (I will use the default `master` branch for this and store the docs in a `/docs` subfolder), the other to host the readily built site (I will use a `site` branch for this).

You'll build the site locally, based on the files in the `master` branch, and then commit the finally built static site to the `site` branch, where they will be - once configured - automatically published by GitHub Pages' *build and deploy* workflow. You may also push these built files to any other webserver, but I'll focus on the GitHub Pages path in this guide.

## Step 1: Create a new GitHub repository

Create a new GitHub repository. This will normally leave you with a `main` branch. Rename this to `master` and clone it to your computer (or keep it, but then replace all the `master` instructions below with `main`).

## Step 2: Create a folder for your sources

Navigate to your local repository (you're in the master branch) and create the `/docs` folder.

```
cd /path/to/your/repository
mkdir docs
cd docs
```

## Step 3: Create a new Jekyll site

We will use the created folder as publishing source and create a new Jekyll site there.

`jekyll new --skip-bundle .`

Open the gemfile that Jekyll created and add "#" to the beginning of the line that starts with `gem "jekyll"` to comment out this line. Then add the github-pages gem by editing the line starting with `# gem "github-pages"`. Change this line to:

`gem "github-pages", "~> GITHUB-PAGES-VERSION", group: :jekyll_plugins`

Replace *GITHUB-PAGES-VERSION* with the latest supported version of the `github-pages` gem. You can find this version here: "[Dependency versions.](https://pages.github.com/versions/)"

Save and close the gemfile and run `bundle install`.

You can optionally preview your site on [http://localhost:4000](http://localhost:4000) after having run `bundle exec jekyll serve`.

Finally build your site using `bundle exec jekyll build`. This will create a `_site` folder, which should already be listed in your `.gitignore` file. If not, do so.

## Step XXX: Checkout a new orphan branch to host your built site

Navigate to your local repository (you're in the master branch), checkout a new *orphan* branch *sources*, and let git remove all its contents:

```
cd /path/to/your/repository
git checkout --orphan site
git rm -rf .
```

## Step XXX: Configure GitHub to the right publishing source

Now it's time to configure GitHub Pages to deploy your site. Go to the settings of your repository, choose *Pages* from the menu, and set the build and deployment source to *Deploy from a branch*, then select your `site` branch and the `/docs` folder.

![Configure your publishing source](/images/github_pages_config.png)
