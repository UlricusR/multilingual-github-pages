---
layout: page
title: Teil III - Mehrsprachigkeit
permalink: "/part3-multilingual/"
lang: de

---
## Teil III: Erstelle die mehrsprachige Seite

Erstellen wir nun die mehrsprachige Seite mit Hilfe des [Polyglot-Plugins](https://github.com/untra/polyglot). Die Seite nutzt das `minima`-Thema von Jekyll. Solltest Du ein anderes Thema verwenden, könnten die Schritte im Detail anders aussehen, im Prinzip aber ähnlich sein.

### Schritt 1: Installiere das Plugin

Gehe in Deine Veröffentlichungsquelle `/docs` und füge folgende Zeilen Deinem `Gemfile` hinzu

    group :jekyll_plugins do
       gem "jekyll-polyglot"
    end

Alternativ kannst Du den gem auch lokal entsprechend der Polyglot README-Datei installieren.

Spezifiziere anschließend das Plugin in Deiner  `_config.yml`-Datei:

    plugins:
      - jekyll-polyglot

Lasse `bundle install` laufen, um die Installation abzuschließen.

### Schritt 2: Konfiguriere das Plugin

Bitte lies im Polyglot README nach, wie man das Plugin konfiguriert. Für meine Zwecke (English als Hauptsprache, Deutsch als zweite Sprache) hat folgende Konfiguration in der `_config.yml`-Datei genügt:

    # Polyglot language plugin settings
    languages: ["en", "de"]
    default_lang: "en"
    exclude_from_localization: ["assets", "javascript", "images", "css", "public"]
    parallel_localization: true

### Schritt 3: Lokalisiere Deine Metadaten

Die Seite nutzt einige Metadaten wir Titel oder Beschreibung, die in der `_config.yml`-Datei gespeichert sind. Du musst jeweils einen sprachspezifischen Titel und eine Beschreibung hinzufügen:

    title:
      en: Multi-lingual GitHub Page
      de: Mehrsprachige GitHub-Seite
    description:
      en: A sample multi-lingual GitHub Page built with a Jekyll plugin not supported by GitHub Pages.
      de: Eine mehrsprachige Demoseite erstellt mit einem von GitHub Pages nicht unterstützten Jekyll-Plugin

Der Titel wird in der `header.html`-Datei des `minima`-Themas genutzt. Daher müssen wir dieses "überschreiben" (override), indem wir einen `_includes`-Ordner im Veröffentlichungsquellverzeichnis `docs` anlegen und dort eine Kopie der Datei aus dem Repositorys des Themas speichern. Dann müssen wir Jekyll in der ersten Zeile der Datei die Sprache wissen lassen, in der wir uns befinden, indem wir diese der Variablen `lang` zuweisen:

    {% raw %}{% assign lang = site.active_lang %}{% endraw %}
    <header class="site-header">
    	...

Nun müssen wir noch die Zeile `{% raw %}{{ site.title | escape }}{% endraw %}` mit der Zeile `{% raw %}{{ site.title[lang] | escape }}{% endraw %}` ersetzen.

Die Beschreibung wird in der `footer.html`-Datei genutzt. Daher wiederholen wir die gleichen Schritte dort, aber ersetzen die Zeile `{% raw %}{{ site.description | escape }}{% endraw %}` mit `{% raw %}{{ site.description[lang] | escape }}{% endraw %}`.

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