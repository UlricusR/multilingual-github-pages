---
layout: page
title: Pre-requisites
permalink: /prerequisites/
lang: en
---

## Assumptions and Pre-Requisites

- You have a GitHub account
- You have git installed on your computer and know how to apply its command line commands (I am working with MacOS terminal, but the git commands should be identical across all platforms)
- You are [authenticated with GitHub](https://docs.github.com/en/authentication) from your command line
- You know the difference between GitHub and git
- You have [Jekyll](https://jekyllrb.com) installed on your computer and are familiar with its basics

## Basic Idea and Procedure

The basic idea is to have one GitHub repository containing two branches, one hosting the source files used by Jekyll to build the site (I will use the default `master` branch for this and store the docs in a `/docs` subfolder), the other to host the readily built site (I will use a `site` branch for this).

You'll build the site locally, based on the files in the `master` branch, and then commit the finally built static site to the `site` branch, where they will be - once configured - automatically published by GitHub Pages' *build and deploy* workflow. You may also push these built files to any other webserver, but I'll focus on the GitHub Pages path in this guide.
