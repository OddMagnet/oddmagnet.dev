---
date: 2022-02-28 20:28
description: Interessante und selten genutzte Optionen für Git-Commands die ich noch nicht kannte - Teil 1
tags: Blog, Tools
---

# Interessante Git-Optionen - Teil 1

Für Git benutze ich am liebsten das "Command Line Interface", auch CLI genannt. Es gibt viele Programme die einen dabei helfen können und die meisten IDEs haben sowas auch schon eingebaut, nichtsdestotrotz hat das Git CLI immer noch Relevanz. Zum einen ist sie unabhängig von der IDE, d.h. wenn ein Programm ein Feature nicht hat kann man auf das CLI zurückgreifen, zum anderen ist es immer gut zu wissen welche Befehle es gibt und wie sie funktionieren. Wirklich tief einsteigen werde ich da nicht in diesem Beitrag, dafür gibt es sicherlich besseres Quellen. Eher möchte ich einfach nur einige - meiner Meinung nach - interessante Optionen und Commands niederschreiben.

## Optionen für bekannte Commands

### Commit

Für `commit` gibt es einige Optionen die ich schon kannte, aber dennoch kurz erwähnen möchte. Zum einen gibt es die `-a` Option, damit werden alle Änderungen gestaged und direkt comitted. Besonders interessant ist diese in Zusammenhang mit der `-m` Option, womit es möglich ist direkt eine "Commit Message" mitzugeben:

```bash
$ git commit -am "Stage alles und commite es mit dieser Message"
```

Persönlich habe ich mir hierfür direkt ein paar Aliase erstellt, `git cm` für einen commit mit einer Message und `git cam` um alles zu stagen und mit einer Nachricht zu comitten. 

**Anmerkung**: Für commit messages gibt es eine Standard-Konvention, eine einzelne Zeile mit einer kurzen Zusammenfassung der Änderung (weniger als 50 Zeichen), eine Leerzeile, und dann eine längere Beschreibung der Gründe für die Änderung, bzw. der Details der Änderung.

Mit der `--amend` Option kann man einen Fehler bei einem Commit im Nachhinein ändern. `git commit --amend -m "Neue Nachricht"` ersetzt die alte Commit Message. Auch ist es möglich eine weitere Datei zu einem Commit hinzuzufügen:

```bash
$ echo "Goodbye World" > bye.txt
$ git add bye.txt
$ git commit --amend -m "Add hello.txt and bye.txt"
```

### Checkout 

Eine Option für `git checkout` die die meisten wahrscheinlich schon kennen ist `-b`, womit man dann direkt einen neuen Branch erstellen und darauf wechseln kann `git checkout -b NewBranch`.

### Diff

Für `git diff` gibt es die `--staged` Option um auch Unterschiede bei gestageten Änderungen anzuzeigen.  Standardmäßig zeigt `git diff` nur Unterschiede für ungestagete und uncommittete Änderungen an. 

### Add

Die allermeisten Git-Nutzer werden die oberen Optionen wahrscheinlich schon kennen, die `-p` Option für `git add` hingegen dürfte wohl etwas unbekannter sein. Wenn es um einzelne Änderungen in Dateien geht greife ich selber auch oft auf GUIs zurück.

Mit der `-p` "patch mode" option bei `git add` kann man einzelne Änderungen - auch "hunks" genannt - bearbeiten, sobald man diesen Modus startet hat man mehrere Optionen:

- "y" (yes) und "n" (no), um die aktuelle Änderung zu stagen, bzw. nicht zu stagen
- "q" (quit), um weder die aktuelle, noch irgendeine der folgenden zu stagen. In anderen Worten man beendet den Modus ohne weitere Änderungen
- "a" (all), um die aktuelle und alle folgenden Änderungen in der aktuellen Datei zu stagen
- "d" (don't), um weder die aktuelle, noch folgende Änderungen in der aktuellen Datei zu stagen
- "/", um in der aktuellen Änderung nach etwas zu suchen ([regex](https://en.wikipedia.org/wiki/Regular_expression))
- "s" (split), um die aktuelle Änderungen aufzuteilen
- "e" (edit), um die aktuelle Änderung zu bearbeiten
- "?", um die Hilfe von dem Modus anzuschauen

Allein diese Optionen und wie man damit wirklich effizient arbeitet würden wahrscheinlich mehrere Beiträge verdienen, aber wie schon vorher geschrieben, dafür gibt es bessere Ressourcen als meinen Blog ;)

### RM

Wenn man `git rm` eine Datei entfernen will, in der es derzeit Änderungen gibt, hat man folgende Optionen: `-f`, womit die Datei auch direkt vom Datenträger gelöscht, und `--cached`, mit der sie nur vom Repository entfernt wird, aber nicht vom Datenträger. 

### Status

Für `git status` gibt es die `-s` Option, die einfach nur für einen kürzeren Output führt, nützlich wenn man sich auskennt und einen sehr schnellen Überblick haben will.

### Log

Einige nette Optionen für `git log` sind:

- `-X`, wobei 'X' eine beliebige Zahl ist, die dann nur die letzten 'X' commits anzeigt
- `--oneline` macht was der Name sagt, commits werden in einer einzelnen Zeile angezeigt
- `--stat` zeigt noch mehr Infos zu den commits, darunter auch farbige '+' und '-' Zeichen
- Auch ist es möglich den Dateinamen anzugeben und nur für die Datei commits zu sehen: `git log Test.txt`
- `--since=1.week` filtert die commits zeitlich, auch möglich sind natürlich `month` und `year`
- `--author` filter die commits nach einem Author
- `-G` filter die commits nach einem gegebenen String: `git log -G "Waldo"`

Eine interessante Alternative zu `git log` ist `git shortlog`, welches die commits nach Autor gruppiert und nur die Titel der commits anzeigt. Standardmäßig wird die Liste nach Autoren sortiert, aber mit der `-n` Option kann man auch nach der Anzahl an Commits sortieren. Wer es noch kürzer haben will kann die `-s` Option nutzen, mit der nur die Anzahl der Commits sowie der Name des Autors angezeigt wird. Kombinieren ist wie immer möglich.

## Teil 2 Vorschau

Im zweiten Teil gehe ich dann noch ein wenig mehr auf auf Branching, Merging, Stashing und Remotes ein, mit ein paar Tipps zum Schluss.