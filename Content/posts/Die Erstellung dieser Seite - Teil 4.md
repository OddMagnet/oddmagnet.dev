---
date: 2022-02-08 16:25
description: Wie diese Seite erstellt wurde, Teil 4.
tags: Blog, Publish, Swift
---
# Eine deutsche Webseite über Swift, erstellt mit Swift - Teil 4

In diesem letzten Teil geht es nun um das hinzufügen von CSS, üblicherweise würde sowas keinen eigenen Teil kriegen, aber da ich Sass benutze und auch zeigen möchte wie man das mit Publish macht gibt es nun einen Teil 4. Ansonsten wir üblich die Anmerkung dass diese Reihe von Posts eher auf einem Anfänger-Niveau sein wird / soll. 

Mit Design bin ich persönlich auf Kriegsfuß, entweder ich verbringe wortwörtlich Stunden mit einem kleinen Detail (und schaffe es dann dennoch nicht dass es mir gefällt), oder ich übertreibe komplett und heraus kommt ein absolutes Design-Monster. Für diese Website habe ich mich entschieden möglichst minimalistisch zu bleiben, hoffentlich sieht die damit nicht nur in meinen Augen akzeptabel aus.

Bevor es losgeht noch eine letzte Abschweifung.

## Ein neues Plugin

Das Splash-Plugin ist super, wenn es nur um das Syntax-Highlighting von Swift geht. Da ich aber immer gerne etwas extra Aufwand betreibe um Zukunftssicher zu sein habe ich nach einem Plugin gesucht was mehrere Sprachen unterstützt.

Dieses habe ich mit dem ["Syntax Highlight Publish Plugin"](https://github.com/nerdsupremacist/syntax-highlight-publish-plugin.git) gefunden. Dieses erfordert ein klein wenig mehr Finesse beim hinzufügen zur `Package.swift` Datei.

```swift
let package = Package(
  name: "OddmagnetDev",
  products: [ /*…*/ ],
  dependencies: [
    .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
    .package(url: "https://github.com/nerdsupremacist/syntax-highlight-publish-plugin.git", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "OddmagnetDev",
      dependencies: [
        "Publish",
        // Hier der wichtige Part, man muss es als .product(...) hinzufügen
        .product(name: "SyntaxHighlightPublishPlugin", package: "syntax-highlight-publish-plugin"),
      ]
    )
  ]
)
```

Dies nutzt man nun ähnlich wie das Splash Plugin in der Publish Pipeline:

```swift
.installPlugin(.syntaxHighlighting([.swift])),
```

Mit dem Hauptunterschied dass man als Argumente noch die Sprachen angibt um die sich das Plugin kümmern soll.

Standardmäßig kommt das Plugin mit support für Swift, aber wie auf der Github Seite des Plugins beschrieben kann man auch relativ einfach weitere Sprachen hinzufügen - solange man an eine `.tmLanguage` Datei für die Sprache rankommt. 

## Ein 'sassy' Plugin

Damit man `Sass` anstatt `CSS` nutzen - oder besser gesagt in die Pipeline einbauen kann - braucht man ein weiteres [Plugin](https://github.com/nerdsupremacist/syntax-highlight-publish-plugin.git), hier die relevanten Zeilen in der `Package.swift` Datei:

```swift
let package = Package(
  /*…*/
  dependencies: [
    /*…*/
    .package(url: "https://github.com/hejki/sasspublishplugin.git", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "OddmagnetDev",
      dependencies: [
        /*…*/
        .product(name: "SassPublishPlugin", package: "sasspublishplugin")
      ]
    )
  ]
)
```

**Wichtig**: neben dem hinzufügen des Packets muss man auch `libsass` installieren: `$ brew install libsass`

Schlussendlich muss man das Plugin dann nur noch in der `main.swift` Datei importieren und installieren:

```swift
/* andere Imports ausgelassen */
import SassPublishPlugin

struct OddmagnetDev: OddWebsite { /*…*/ }

try OddmagnetDev().publish(using: [
  /* andere Schritte in der Pipeline ausgelassen */
  .installPlugin(
    .compileSass(
      sassFilePath: "Resources/OddTheme/sass/styles.sass",
      cssFilePath: "styles.css"
    )
  )
])
```

**Wichtig:** meine Theme nutzt den standard `.head()` von Publish, welcher ohne weitere Angabe einfach die `styles.css` im Root-Verzeichnis nutzt. Wenn ihr eure CSS Datei woanders haben wollt müsst ihr nicht nur beim Plugin den Pfad ändern, sondern auch in eurer Theme.

## Schlusswort

Das war es erstmal für diese Eröffnungsreihe von Posts für meine Seite. Wie schon im ersten Teil erwähnt bin ich bei weitem kein Experte (und schon recht kein Designer). Es gibt noch viel zu tun bevor diese Seite (und auch meine Theme) auf dem Stand sind wo ich sie sehen möchte.

Wenn ihr Fragen oder Feedback habt, oder mir gar helfen wollt, schreibt mir einfach eine E-Mail. Schlussendlich ist eins meiner Ziele mit dieser Seite ja auch den Kontakt zu anderen deutschen Entwicklern aufzubauen :)
