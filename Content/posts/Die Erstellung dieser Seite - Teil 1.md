---
date: 2022-02-08 16:22
description: Wie diese Seite erstellt wurde, Teil 1.
tags: Blog, Publish, Swift
---
# Eine deutsche Webseite über Swift, erstellt mit Swift - Teil 1

## Ein kleines Vorwort

Bevor es zum eigentlich Post geht wollte ich erstmal kurz meine Gründe für die Erstellung dieser Webseite nennen, damit wisst ihr (die Leser) direkt womit ihr hier rechnen könnt: 

- Ich wollte gerne eine eigene Webseite haben, die mithilfe von `Markdown` Dateien und Swift erstellt wird
- Andere deutschsprachige Seiten zu Swift scheinen inaktiv zu sein, daher die Entscheidung auf deutsch zu schreiben
- Bisher kenne ich persönlich keine anderen deutschen Swift-Entwickler, vielleicht lerne ich so ja ein paar kennen
- Ich bin kein Experte was iOS-Entwicklung angeht, dennoch möchte ich Sachen die ich lerne und interessant finde hier teilen, Feedback ist natürlich gerne gesehen 
- Hoffentlich hilft diese Sideproject auch ein wenig dabei eine Firma zu finden die mir trotz meiner Krankheitsgeschichte eine Chance gibt :)

## Erste Schritte

Eine letzte Sache noch bevor es losgeht, diese Reihe an Blogposts ist mehr eine Zusammenfassung meiner Auseinandersetzung mit dem [Publish](https://github.com/JohnSundell/Publish) Projekt von [John Sundell](https://github.com/JohnSundell/), wer also lieber etwas ausführlicheres auf englisch lesen möchte sollte dort mal reinschauen. Generell wird diese Reihe von Posts eher auf einem Anfänger-Niveau sein.

### Publish installieren

Grundsätzlich hat man zwei Möglichkeiten wie man Publish nutzen kann, entweder man fügt es über den Swift Package Manager zu einem bestehenden Projekt hinzu, oder man nutzt das Kommandozeilen Tool um ein neues Projekt zu erstellen. Für dieses Projekt nutze ich letztere Möglichkeit.

Das Kommandozeilen Tool kann man auf 2 Wegen installieren, durch das klonen des [Publish](https://github.com/JohnSundell/Publish) Repositories und dem ausführen der `makefile`:

```bash
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
```

Oder durch die Installation mit [Brew](https://brew.sh). 

```bash
$ brew install publish
```

Persönlich bin ich ein großer Fan von Brew, daher habe ich selber diese Variante gewählt.

### Ein neues Projekt erstellen

Nachdem das Kommandozeilen Tool installiert ist braucht es nur noch einen neuen, leeren Ordner für das Projekt

```bash
$ mkdir PROJEKT-NAME
$ cd PROJEKT-NAME
$ publish new
```

Jetzt kann man die von Publish generierte `Package.swift` Datei öffnen

```bash
$ open Package.swift
```

Alternativ kann man die Datei natürlich auch einfach doppelklicken.

Jetzt kann man das Projekt auch schon direkt ausführen, mit `⌘+R` oder über `Product > Run`. Wenn man das zum ersten Mal macht kommt eventuell noch eine kurze Abfrage für die Nutzung der "Command Line Tools" und noch eine für den Zugriff auf den Ordner in dem der Projekt-Ordner ist.

Wenn alles geklappt hat sollte man in Xcode folgenden Output bekommen

```bash
Publishing PROJEKTNAME (6 steps)
[1/6] Copy 'Resources' files
[2/6] Add Markdown files from 'Content' folder
[3/6] Sort items
[4/6] Generate HTML
[5/6] Generate RSS feed
[6/6] Generate site map
✅ Successfully published PROJEKTNAME
Program ended with exit code: 0
```

### Lokal entwickeln und testen

Damit man die Webseite auch direkt anschauen kann hat Publish auch ein Kommando:

```bash
$ publish run
```

Beim ersten Ausführen ladet sich das Tool erstmal so einige Dateien von Github, kompiliert diese und generiert schlussendlich auch die Webseite, diese kann man dann über `http://localhost:8000` erreichen.

Um den Inhalt der Seiten neu zu generieren während der Server läuft nutzt man einfach wieder `Product > Run` in Xcode.

### Webseite online verfügbar machen

Um die Webseite dann im Internet verfügbar zu machen nutzt man den `deploy` schritt in der Publishing Pipeline. In der `main.swift` Datei (im `Sources > PROJEKTNAME` Ordner) ändert man dazu

```swift
try PROJEKTNAME().publish(withTheme: .foundation)
```

zu

```swift
try PROJEKTNAME().publish(using: [
    .copyResources(),
    .addMarkdownFiles(),
    .sortItems(by: \.date),
    .generateHTML(withTheme: .foundation),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("USERNAME/PROJEKT-NAME"), branch: "main")
])
```

Im obigen Beispiel wurden einfach alle Schritte die bei `.publish(withTheme: .foundation)` ausgeführt wurden auch wieder gelistet. Generell sind die Schritte optional, wer beispielsweise kein RSS Feed haben will kann den Schritt dafür einfach weglassen. 

Der für diesen Teil des Beitrags relevante `deploy` Schritt wird allerdings nur ausgeführt wenn das `--deploy` flag vorhanden ist. Das kann man dann entweder direkt über die Kommandozeile machen:

```bash
$ publish deploy
```

Oder indem man das `Scheme` in Xcode ändert, `Product > Scheme > Edit Scheme…`.

Persönlich nutze ich dafür immer die Kommandozeile, denn so gehe ich wirklich sicher dass ich nicht aus Versehen irgendwelche Änderungen veröffentliche bevor diese wirklich fertig sind.

Eine Sache die ich für meine Webseite noch zusätzlich gemacht habe, ist ein weiterer Branch, `author`, in dem sich dann sowohl die `.md` Dateien wie auch die Quelldateien für meine Webseite befinden. Änderungen kann ich so erst lokal testen bis ich zufrieden bin, dann den `author` branch comitten und über `publish deploy` wird die generierte Seite dann auf den `main` branch gepushed.
