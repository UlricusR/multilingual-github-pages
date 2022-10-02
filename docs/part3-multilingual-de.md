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

### Schritt 4: Lokalisiere den Titel-Tag

Als nächsten Schritt müssen wir uns um den `<title>`-Tag in Jekylls eingebautem SEO-Abschnitt kümmern, weil die Seitenbeschreibung dort ebenfalls genutzt wird. Der Titel-Tag wird von Suchmaschinen benötigt, aber auch von den meisten Browsern als Tab-Bezeichnung genutzt. Da wir Jekyll keinen modifizierten Titel mitgeben können, müssen wir den diesen dort deaktivieren und stattdessen unseren eigenen Titel-Tag ausgeben.

Dafür müssen wir Minimas `head.html`-Datei überschreiben (und zusätzlich die `custom-head.html`-Datei, sonst gibt es eine Fehlermeldung). Kopiere also beide Dateien aus Minimas Repository in Dein `_includes`-Verzeichnis und bearbeite `head.html` (`custom-head.html` kannst Du unberührt lassen, aber später für weitere Anpassungen, z.B. ein Favicon, nutzen).

Ersetze die Zeile `{% raw %}{%- seo -%}{% endraw %}` mit `{% raw %}{%- seo title=false -%}{% endraw %}`.

> Aus irgendwelchen Gründen, die ich nicht weiter verfolgt habe, hat das Überschreiben von `head.html` zu einem korrupten Stylesheet-Link geführt. Ich musste die Zeile `<link rel="stylesheet" href="{{ "/assets/css/style.css" | relative_url }}">` zu `<link rel="stylesheet" href="{{ "/assets/main.css" | relative_url }}">` ändern, um das zu reparieren.

Nun musst Du noch Deinen eigenen Titel-Tag in  `head.html` hinzufügen. Als erste Zeile lassen wir Jekyll wieder die Sprache wissen:

`{% raw %}{% assign lang = site.active_lang %}{% endraw %}`

Dann füge den folgenden Code am besten vor der Zeile `{% raw %}{%- seo title=false -%}{% endraw %}` ein:

    {% raw %}<title>
      {% if page.title %}{{ page.title }} - {% endif %}
      {% if site.title[lang] %}{{ site.title[lang] }}{% endif %}
    </title>{% endraw %}

Dadurch wird der Seitentitel gesetzt, falls im frontmatter der Datei definiert, und dann der lokalisierte Webseitentitel angehängt, getrennt durch einen Bindestrich.

### Schritt 5: Lokalisiere Dein Hauptmenü

In Minima kann man die Reihenfolge der angezeigten Menüeinträge in der `_config.yml`-Datei festlegen. Wir müssen dies separat für alle Sprachen machen:

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

Ändere danach in der `header.html`-Datei `{% raw %}{%- assign page_paths = site.header_pa`_`es | default: default_paths -%}{% endraw %}` zu `{% raw %}{%- assign page_paths = site.header_pages[lang] | default: default_paths -%}{% endraw %}`.

### Schritt 6: Lokalisiere Deine Seiten

Seiten werden lokalisiert, indem eine eigene Quelldatei pro Sprache angelegt und jeweils der Sprachcode an den Dateinamen angehängt wird. Mit Englisch als Haupt- und Deutsch als Zweitsprache, benötigen wir in diesem Tutorial für jede Seitenquelldatei eine `...-en.md`-Version und eine `...-de.md`-Version (gilt auch für `html`-Dateien).

Zusätzlich muss jede dieser zusammengehörigen Dateien den identischen `permalink` und den passenden `lang`-Tag im Frontmatter haben.

Benenne also z.B. `index.md` in `index-en.md` um und füge folgende Zeilen im Frontmatter hinzu:

    ---
    layout: home
    permalink: /
    lang: en
    ---

Dupliziere dann die Datei, speichere sie als `index-de.md`. Übersetze sie und ändere die Frontmatter zu:

    ---
    layout: home
    permalink: /
    lang: de
    ---

Wichtig: Der Permalink muss in allen zusammengehörigen Dateien identisch sein!

Wiederhole diese Prozedur für alle zu übersetzenden Dateien, z.B. für `about.md`, das zu `about-en.md` wird mit folgendem Frontmatter:

    ---
    layout: page
    title: About
    permalink: /about/
    lang: en
    ---

Die `about-de.md`-Datei hat dann folgendes Frontmatter:

    ---
    layout: page
    title: Über
    permalink: /about/
    lang: de
    ---

### Schritt 7: Lokalisiere Deine Posts

Lege im `_posts`-Ordner einen Unterordner mit dem Namen des Sprachkürzels für jede _zusätzliche_ Sprache an (nicht für die Default-Sprache!). In meinem Fall ist das lediglich der Ordner `docs/_posts/de`. Kopiere alle Posts, die Du übersetzen willst, in diesen Ordner. Wenn Du einen weglässt, wird das Polyglot-Plugin die Datei der Default-Sprache nutzen (siehe den `Welcome to Jekyll`-Post in meiner Beispielseite, den ich zu Demozwecken nicht übersetzt habe).

Ändere auf keinen Fall den Dateinamen der Posts im Sprachordner!

Füge schließlich den `lang`-Tag im Frontmatter aller Posts hinzu (auch in denen der Default-Sprache).

### Schritt 8: Füge einen Sprachwechsler hinzu

Um den Nutzern das Wechseln der Sprache zu ermöglichen, benötigen wir einen Sprachwechsler im `header.html`. Füge folgenden Code vor dem schließenden `</header>`-Tag hinzu:

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

Rolle Deine Seite mit dem `deploy.sh`-Script aus und Du solltest Deine erste mehrsprachige Jekyll-Webseite im Netz finden.