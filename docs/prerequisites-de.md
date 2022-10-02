---
layout: page
title: Voraussetzungen
permalink: /prerequisites/
lang: de
---

## Annahmen und Voraussetzungen

- Du hast einen GitHub-Account
- Du hast git auf Deinem Rechner installiert und weißt, wie Du es per Command Line bedienst (ich arbeite mit dem MacOS-Terminal, aber die git-Befehle sollten auf allen Plattformen gleich sein)
- Du bist [auf GitHub authentifiziert](https://docs.github.com/en/authentication) auf Deiner Command Line
- Du kennst die Unterschiede zwischen GitHub und git
- Du hast [Jekyll](https://jekyllrb.com) auf Deinem Rechner installiert und kennst dessen Basics

## Grundidee und Vorgehen

Die Grundidee ist, ein GitHub-Repository mit zwei Branches zu haben, wobei der eine die Quelldateien beinhaltet, die Jekyll für die Erstellung der Seite nutzt (ich werde dafür in diesem Tutorial den `master`-Branch nutzen und die Quelldateien in einem `/docs`-Unterordner speichern), und der andere die Seiten-Dateien der fertig erstellten Webseite beinhaltet (ich nutze dafür den `site`-Branch).

Du wirst die Seite lokal erstellen unter Nutzung der Dateien im `master`-Branch und dann die fertig erstellte Seite im `site`-Branch einchecken, von wo sie - sobald konfirguiert - automatisch vom *build and deploy*-Workflow von GitHub Pages publiziert werden. Natürlich kannst Du sie auch auf jeden anderen Webserver hochladen, ich fokussiere hier aber auf GitHub Pages.
