---
layout: page
title: Teil I - Einrichtung
permalink: /part1-setup/
lang: de
---

## Teil I: Erstelle Deine GitHub Pages Seite

### Schritt 1: Erstelle ein neues GitHub-Repository

Erstelle ein neues GitHub-Repository. Es wird automatisch den `main`-Branch anlegen. Ich habe diesen zu `master` umbenannt. Mach auch Du das und klone ihn dann auf Deinen Computer (oder behalte `main` bei, ersetze dann aber alle `master` in diesem Tutorial durch `main`).

Solltest Du die Seite in einem bestehenden Repository hinzufügen wollen, wird empfohlen, die Seitenquelldateien in einem *leeren, nicht-verbundenen* Branch, einem sogenannten *orphan*-Branch zu tun. Wir könnten diesen `site-sources` nennen:

```
git checkout --orphan site-sources
git rm -rf .
```

Solltest Du diesen Weg nehmen, ersetze bitte alle Anweisungen dieses Tutorials, die sich auf den `master`-Branch beziehen, mit dem `site-sources`-Branch (oder wie auch immer er bei Dir heißt).

### Schritt 2: Erstelle einen Ordner für Deine Quelldateien

Wechsle in Dein lokales Repository (Du müsstest im master-Branch sein) und erstelle ein `/docs`-Verzeichnis.

```
cd /pfad/zu/deinem/repository
mkdir docs
cd docs
```

### Schritt 3: Erstelle eine neue Jekyll-Seite

Wir nutzen den erstellten Ordner als Publishing-Source und erstellen dort eine neue Jekyll-Seite.

`jekyll new --skip-bundle .`

Öffne das gemfile, das Jekyll erstellt hat, und füge "#" an den Anfang der Zeile hinzu (auskommentieren), die mit  `gem "jekyll"` beginnt. Füge dann den GitHub-Pages-Gem hinzu, indem Du die Zeile, die mit `# gem "github-pages"` beginnt, bearbeitest. Ändere sie zu:

`gem "github-pages", "~> GITHUB-PAGES-VERSION", group: :jekyll_plugins`

Ersetze hierbei *GITHUB-PAGES-VERSION* mit der jüngsten unterstützten Version des GitHub-Pages-Gems. Du findest diese hier: "[Dependency versions.](https://pages.github.com/versions/)"

Speichere und schließe das gemfile und führe `bundle install` aus.

Da sich Deine GitHub-Seite in einem Unterverzeichnis befindet (hier: ulricusr.github.io/*multilingual-github-pages/*), musst Du die `baseurl` zu Jekzlls Konfigurationsdatei `_config.yml` in Deinem `/docs`-Verzeichnis hinzufügen: `baseurl: <Dein Repository-Name>`.

Optional kannst Du Deine Seite jederzeit lokal anzeigen lassen auf [http://localhost:4000/multilingual-github-pages](http://localhost:4000/multilingual-github-pages), nachdem Du `bundle exec jekyll serve` ausgeführt hast.

Lasse die Seite schließlich mit `bundle exec jekyll build` erstellen. Dies erzeugt einen `_site`-Ordner, der bereits in Deiner `.gitignore`-Datei eingetragen sein sollte. Falls nicht, mach es.

### Schritt 4: Checke Deine Quelldateien in Dein GiHub-Repository ein

Gehe dazu in das Wurzelverzeichnis Deines lokalen git-Repositorys, füge die erstellten Dateien hinzu (add) und checke sie ein (commit - inkl. des `/docs`-Verzeichnisses und unter Ausschluss des `/docs/_site`-Verzeichnisses). Lade sie schließlich in Dein Remote-Repository hoch (push).

```
cd ..
git add -A
git commit -m "Initial commit"
git push
```

Deine Quelldateien sollten sich nun in Deinem GitHub-Repository befinden. Nun kümmern wir uns um die generierten Seiten-Dateien.

### Schritt 5: Erstelle ein neues lokales Repository für Deine Seitendateien

Wechsle zu `/docs/_site` und initialisiere ein neues lokales Repository mit dem gleichen Remote-Repository wie oben.

```
cd docs/_site/
git init .
git remote add origin https://github.com/<dein-benutzername>/<dein-repo-name>
```

Da die Seitendateien in einen separaten `site`-Branch hochgeladen werden sollen, müssen wir diesen erstellen mittels `git branch site`.

### Schritt 6: Bereite Deine Seitendateien vor und lade sie in Dein Remote-Repository hoch

Bevor wir Deine Seitendateien hochladen, müssen wir noch eine neue, leere Datei namens `.nojekyll` erstellen. Sie stellt sicher, dass GitHub Pages die Seitendateien nicht prozessiert, sondern wie hochgeladen ausrollt.

`touch .nojekyll`

Füge nun alle Seitendateien zu Deinem Repository hinzu, checke sie ein und lade sie in Dein Remote-Repository hoch. Da der Branch auf GitHub noch nicht existiert, müssen wir ihn mittels der `-u`-Option erstellen.

```
git add -A
git commit -m "Initial commit"
git push -u origin site
```

Deine Seiten-Dateien sollten sich nun im `site`-Branch Deines GitHub-Repositorys befinden.

### Schritt 7: Konfiguriere GitHubs Veröffentlichungsquelle

Der letzte Schritt ist, die Veröffentlichungsquelle (publishing source) in GitHub zu konfigurieren. Gehe dazu zu den Einstellungen Deines Repositorys, wähle *Pages* im Menü, und stelle die build and deployment source auf *Deploy from a branch*. Wähle dann Deinen `site`-Branch aus und behalte den `/(root)`-Ordner bei. Speichere, warte ca. eine Minute und prüfen dann Deinen Onlinepräsenz mittels des "Visit site"-Knopfs.

![Configure your publishing source]({{ "/assets/images/github_pages_config.png" | relative_url }})
