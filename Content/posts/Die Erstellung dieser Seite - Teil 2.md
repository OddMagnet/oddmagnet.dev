---
description: Wie diese Seite erstellt wurde, Teil 2.
tags: Blog, Publish, Swift
---
# Eine deutsche Webseite über Swift, erstellt mit Swift - Teil 2

In diesem Teil geht es um die Installation und Konfiguration des Splash Plugins für Publish, dieses findet man (unter anderem) hier: [Publish Community Plugins](https://github.com/topics/publish-plugin?l=swift). Wer selber ein Plugin für Publish entwickeln möchte sollte auf jeden Fall das `publish-plugin` topic zu dem Repository hinzufügen (siehe [hier](https://help.github.com/en/github/administering-a-repository/classifying-your-repository-with-topics#adding-topics-to-your-repository)), dadurch ist das Plugin direkt bei den anderen Community Plugins aufzufinden. Wie in Teil 1 erwähnt wird diese Reihe von Posts eher auf einem Anfänger-Niveau sein.

## Installation am Beispiel von Splash

Um ein Plugin zu nutzen muss man es zuerst zu den Dependencies in der `Package.swift` Datei hinzufügen, diese sieht direkt nach der Nutzung von `publish new` erstmal so aus:

```swift
let package = Package(
    name: "OddmagnetDev",
    products: [
        .executable(
            name: "OddmagnetDev",
            targets: ["OddmagnetDev"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "OddmagnetDev",
            dependencies: ["Publish"]
        )
    ]
)
```

Am Beispiel des [Splash Plugins](https://github.com/JohnSundell/SplashPublishPlugin) sähe das dann so aus:

```swift
let package = Package(
    /* Code ausgelassen */ 
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "OddmagnetDev",
            dependencies: [
                "Publish",
                "SplashPublishPlugin"
            ]
        )
    ]
)
```

Das allein reicht natürlich nicht aus, damit das Plugin auch was macht muss es in der publishing pipeline genutzt werden, in der `main.swift`:

```swift
/* Vorherige imports ausgelassen */
import SplashPublishPlugin

struct OddmagnetDev: Website { /*...*/ }

try OddmagnetDev().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
  	/* alle weiteren Schritte */
])
```

## CSS Datei für Splash hinzufügen

Im Falle von Splash wird auch noch eine `styles.css` Datei benötigt, für einen guten Startpunk empfehle ich die [Beispiel CSS Datei](https://github.com/JohnSundell/Splash/blob/master/Examples/sundellsColors.css) von John Sundell.

Diese kann man leider nicht ohne weiteres nutzen, solange man die `Foundation` Theme verwendet. Idealerweise erstellt man sich seine eigene Theme in der die CSS Datei dann genutzt wird.

Da ich in einem späteren Beitrag über die Erstellung einer eigenen Theme gehen will zeige ich in diesem Artikel nur einen "Workaround" wie man die CSS Datei für das Syntax Highlighting auch mit dem `Foundation` Theme "nutzen" kann.

Zuerst erstellt man einen neuen Ordner für die "eigene" Theme `Resources > ThemeName`, in diesem kommt dann die CSS Datei für das Publish plugin, ich habe sie einfach `splash.css` genannt. Zusätzlich erstellt man auch noch eine CSS Datei für die eigentliche Theme, `styles.css`, in diese kopiert man dann den Inhalt der von `Publish > Resources > FoundationTheme > styles.css`.

Als nächstes erstellt man einen Ordner für den Code der "eigenen" Theme `Sources > ProjektName > ThemeName`, sowie eine `Theme+ThemeName.swift` Datei. Dort kopiert man den Inhalt  von `Publish > Sources > Publish > API > Theme+Foundation.swift` rein.

Nun muss man diese Datei noch ein wenig anpassen, zum einen wird ein `import Publish` benötigt, zum anderen sollte man den Namen für die Theme ändern, sowie die Pfade für die CSS Dateien anpassen, das sollte dann so aussehen:

```swift
import Plot
import Publish

public extension Theme {
    static var themeName: Self { // hier den Namen der Variable ändern
        Theme(
            htmlFactory: ThemeNameHTMLFactory(),	// den Factory Namen auch entsprechend anpassen
            resourcePaths: [	// und die Pfade für die CSS Dateien anpassen
                "Resources/ThemeName/styles.css",
                "Resources/ThemeName/splash.css"
                ]
        )
    }
}

// Die Factory selber muss natürlich auch umbenannt werden
private struct ThemeNameHTMLFactory<Site: Website>: HTMLFactory { /*…*/ }
```

Zuletzt muss man die `makeItemHTML` Funktion in der `ThemeNameHTMLFactory` anpassen, damit diese auch die CSS Dateien verlinkt. Das sollte dann so aussehen:

```swift
func makeItemHTML(for item: Item<Site>,
                  context: PublishingContext<Site>) throws -> HTML {
  HTML(
    .lang(context.site.language),
    .head(
      for: item,
      on: context.site,
      stylesheetPaths: [
        "/styles.css",
        "/splash.css"
      ]
    ),
    /* Code ausgelassen */
  )
}
```

Sollte ihr die CSS Datei für das Splash Plugin anders genannt haben müsst ihr das natürlich auch anpassen.

Wenn man die Seite nun neu generiert (`⌘ + R`) sieht man: nichts. Denn bisher nutzt die Publishing Pipeline immer noch die Foundation Theme. In der `main.swift` muss man noch das `withTheme: .foundation` ändern:

```swift
try OddmagnetDev().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
  	/* Schritte ausgelassen */ 
    .generateHTML(withTheme: .themeName),
  	/* Schritte ausgelasse */
])
```

Noch ein letztes Mal die Seite neu generieren und die Code-Blöcke sollten nun schön markiert sein.

In dem nächsten Artikel geht es dann darum, wie man sich eine eigene Theme erstellt.
