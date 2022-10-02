---
layout: page
title: Part III - Multilingual
permalink: "/part3-multilingual/"
lang: en

---
## Part III: Building the multi-lingual site

Let's now build our multilingual site using the [Polyglot plugin](https://github.com/untra/polyglot). The site is based on Jekyll's `minima` theme, so if you use another theme, the steps might look different in detail, but should be rather similar.

### Step 1: Install the plugin

Navigate to your publishing source directory `/docs` and add the following to your `Gemfile`:

    group :jekyll_plugins do
       gem "jekyll-polyglot"
    end

Alternatively, install the gem locally following the description in the Polyglot README.

Then specify the plugin in your `_config.yml`:

    plugins:
      - jekyll-polyglot

Run `bundle install` to finalize the installation.

### Step 2: Configure the plugin

Please refer to the Polyglot README for details on the configuration. For my purposes (English as default language, German as second language), the following configuration in `_config.yml` was sufficient:

    # Polyglot language plugin settings
    languages: ["en", "de"]
    default_lang: "en"
    exclude_from_localization: ["assets", "javascript", "images", "css", "public"]
    parallel_localization: true

### Step 3: Localize your metadata

The site will use some metadata like the title or the description, which are stored in the `_config.yml` file. You need to add a language specific title and description:

    title:
      en: Multi-lingual GitHub Page
      de: Mehrsprachige GitHub-Seite
    description:
      en: A sample multi-lingual GitHub Page built with a Jekyll plugin not supported by GitHub Pages.
      de: Eine mehrsprachige Demoseite erstellt mit einem von GitHub Pages nicht unterstützten Jekyll-Plugin

The title is used in the `header.html` file of the `minima` theme. Therefore we need to override the remote `header.html` file by creating a `_includes` folder in the top level publishing folder (here: `docs`) and save a copy there. Next, we need to let Jekyll know which language we're in by adding the following line as first line in `header.html`, which creates the variable `lang` and assigns the current language:

    {% raw %}{% assign lang = site.active_lang %}{% endraw %}
    <header class="site-header">
    	...

Finally, we need to modify the line containing `{% raw %}{{ site.title | escape }}{% endraw %}` with `{% raw %}{{ site.title[lang] | escape }}{% endraw %}`.

The description is used in the `footer.html` file, so simply repeat the steps above, but replace `{% raw %}{{ site.description | escape }}{% endraw %}` with `{% raw %}{{ site.description[lang] | escape }}{% endraw %}`.

### Step 4: Localize your title tag

As a last step, we have to take care of the `<title>` tag in Jekyll's built-in SEO section, because the site description is also used there. The title tag is used by search engines, but also by most browsers to name the browser tab. As we cannot pass a custom title to Jekyll's SEO section, we need to disable the display of the title there and create our own `<title>` tag instead.

To do so, we need to override Minima's `head.html` (and along with it the `custom-head.html`, otherwise we'd run into an error when building the site). So copy those two files from Minima's `_includes` folder to your `_includes` folder and open `head.html` for editing (you can leave `custom-head.html` untouched, but may also use for further customizations like adding a favicon).

Modify the line `{% raw %}{%- seo -%}{% endraw %}` to `{% raw %}{%- seo title=false -%}{% endraw %}`.

> For some reason, which I didn't dig in deeper, overriding `head.html` lead to my site no longer finding the right stylesheet. I had to change the line `<link rel="stylesheet" href="{{ "/assets/css/style.css" | relative_url }}">` to `<link rel="stylesheet" href="{{ "/assets/main.css" | relative_url }}">` to fix it.

Finally, we'll have to add our own custom title in `head.html`. As very first line of the file, set the language by adding `{% raw %}{% assign lang = site.active_lang %}{% endraw %}`.

Then add the following code before the modified `{% raw %}{%- seo title=false -%}{% endraw %}` line:

    {% raw %}<title>
      {% if page.title %}{{ page.title }} - {% endif %}
      {% if site.title[lang] %}{{ site.title[lang] }}{% endif %}
    </title>{% endraw %}

It will add the page title, if set in the frontmatter of the file, and then append the localized site title, separated by a slash.

### Step 5: Localize your main menu

Minima allows you to define the order of the top menu items by adding those to `_config.yml`. We need to do this for all languages:

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

Next, in `header.html` change `{% raw %}{%- assign page_paths = site.header_pages | default: default_paths -%}{% endraw %}` to `{% raw %}{%- assign page_paths = site.header_pages[lang] | default: default_paths -%}{% endraw %}`.

### Step 6: Localize your pages

Pages are localized by adding one file per language and using the language code to extend the filename. With `en` being the default language and `de` the additional language for this example, we will need to have a `...-en.md` and a `...-de.md` version for each file we want to localize (also works with `html` files).

In addition, we need to add the identical `permalink` and a `lang` tag to the frontmatter of each file.

So, rename your `index.md` to `index-en.md` and add the following lines to the frontmatter:

    ---
    layout: home
    permalink: /
    lang: en
    ---

Duplicate the file and save it as `index-de.md`. Translate the content and add the following lines to the frontmatter:

    ---
    layout: home
    permalink: /
    lang: de
    ---

It is very important to have the permalink identical in all language files.

Repeat the same procedure for all your pages. My `about.md`, for example, becomes `about-en.md` and has the following frontmatter:

    ---
    layout: page
    title: About
    permalink: /about/
    lang: en
    ---

My `about-de.md` has the following frontmatter:

    ---
    layout: page
    title: Über
    permalink: /about/
    lang: de
    ---

### Step 7: Localize your posts

In the `_posts` folder, create a subfolder for each _additional_ language (not the default language!). In my case, I only created a `docs/_posts/de` folder. Copy all posts, which you want translated, into that folder. If you leave a post away, the Polyglot plugin will use the default language post instead (see the `Welcome to Jekyll` post in my sample site for a demonstration of this feature).

Don't change the filename of the post in the language subfolder!

Finally, add the `lang` tag in the frontmatter of all posts (also those in the default language).

### Step 8: Add a language switcher

To enable the user to switch between languages, I added a language switcher in `header.html`. Add the following code before the closing `</header>` tag:

```html
{% raw %}<div class="wrapper">
  {% assign is_first_language = true %}
  <!-- jekyll-polyglot will process ferh= into href= through the static_href liquid block tag without relativizing the url; useful for making language navigation switchers  -->
  {% for tongue in site.languages %}
    {% if is_first_language == false %}|{% endif %}
    <a {% if tongue == site.active_lang %}style="font-weight: bold;"{% endif %} {% static_href %}href="{% if tongue == site.default_lang %}{{site.baseurl}}{{page.url}}{% else %}{{site.baseurl}}/{{ tongue }}{{page.url}}{% endif %}"{% endstatic_href %} >{{ tongue }}</a>
    {% assign is_first_language = false %}
  {% endfor %}
</div>{% endraw %}
```

Deploy your site using the `deploy.sh` script and you should be good to go with your first multilingual Jekyll site.