# Building a Multi-Lingual GitHub Page with Unsupported Jekyll Plugins

*A step-by-step guide to build a multi-lingual website using Jekyll plugins not supported by GitHub Pages*

GitHub Pages offers great possibilities to host static, version controlled homepages. One downside is the support for only a [limited amount of jekyll-plugins](https://pages.github.com/versions/). I was especially interested in using the [jekyll-multiple-language-plugin](https://github.com/kurtsson/jekyll-multiple-languages-plugin), because my website needed to be available in English and German.

As GitHub Pages does not support this specific plugin, I searched for workarounds. The most promising one I found in [Dani's Braindump blog](https://tiefenauer.github.io/blog/gh-pages-plugins/). I will describe my experience in setting up a multi-language site in GitHub Pages in the following step-by-step guide.

You can also use this repository as a blueprint to start your own multi-lingual website. Just fork it and use the file structure as a template. However, do read the following steps carefully, as you'll need to understand how to set up and maintain your website.

## Assumptions and Pre-Requisites

- You have a valid GitHub account
- You have git installed on your computer and know how to apply its command line commands (I am working with MacOS terminal, but the git commands should be identical across all platforms)
- You know the difference between GitHub and git
- You have [jekyll](https://jekyllrb.com) installed on your computer and are familiar with its basics

## Basic Idea and Procedure

The basic idea is to have one GitHub repository containing two branches, one hosting the source files used by jekyll to build the site (I will use the `sources` branch for this), the other to host the readily built site (I will use the `master` branch for this).

You'll build the site locally, based on the files in the `sources` branch, and then commit the finally built static site to the `master` branch, where they will be automatically published by GitHub Pages' *build and deploy* workflow. You may also push these built files to any other webserver, but I'll focus on the GitHub Pages path in this guide.

## Step 1: Create a new GitHub repository

Create a new GitHub repository. This will normally leave you with a `main` branch. Rename this to `master` and clone it to your computer (or keep it, but then replace all the `master` instructions below with `main`). You may as well use an existing repository with an *empty* new branch (for example a branch called site, which you can create locally: `git checkout --orphan site`).

Whatever way you choose, I will for this tutorial talk about the `master` branch, which will at the end contain all finally built webpages, which GitHub Pages will automatically deploy.

## Step 2: Configure GitHub to the right publishing source

I prefer the website files to reside in a subfolder of my repository, usually */docs*. Go to the settings of your repository, choose *Pages* from the menu, and set the build and deployment source to *Deploy from a branch*, then select your `master` branch and the */docs* folder.

![Configure your publishing source](/images/github_pages_config.png)

## Step 3: Checkout a new orphan branch

Navigate to your local repository (you're in the master branch), checkout a new *orphan* branch *sources*, and let git remove all its contents:

```
cd /path/to/your/repository
git checkout --orphan sources
git rm -rf .
```
