---
date: 2022-02-08 16:24
description: Wie diese Seite erstellt wurde, Teil 3.
tags: Blog, Publish, Swift
---
# Eine deutsche Webseite über Swift, erstellt mit Swift - Teil 3

Wie im letzten Teil schon erwähnt dreht sich dieser Teil hauptsächlich um das hinzufügen eines eigenen Themes. Ansonsten wir üblich die Anmerkung dass diese Reihe von Posts eher auf einem Anfänger-Niveau sein wird / soll. 

Was ich ursprünglich vermeiden wollte war es meine Theme selber zu erstellen, da ich von Design wenig Ahnung habe. Mit jeder zusätzlichen Zeile CSS erhöht sich die Wahrscheinlichkeit dass meine Website nachher einfach grausam aussieht.

Wie man das als Entwickler dann halt so macht googlet man erstmal nach vorhandenen Lösungen für das eigene Problem. Wirklich viel finden wird man allerdings nicht. Publish ist vergleichsweise relativ unbekannt. Die Blogs deren Code man auf Github einsehen kann haben alle kaum Änderungen in der Theme und von denen, die sich wirklich abheben, kann man den Code nicht einsehen.

Bleibt also nur übrig, doch eine eigene Theme zu erstellen.

## Die Basics

Um eine eigene Theme für Publish zu erstellen benötigt man einige Sachen:

- Ein Protokoll für die eigene Theme, wenn man extra Funktionen einbauen will
- Eine HTMLFactory, die das HTML für die Seite erzeugt
- Eine Extension auf Theme, in der man dann in einer statische Variable seine Theme inklusive HTMLFactory bereit stellt.

Für diesen Post werde ich das ganze von hinten auflösen, die Extension selber ist das einfachste und benötigt nur einige wenige Zeilen:

### Extension auf Theme

```swift
public extension Theme where Site: OddWebsite {	// 1
  static var oddTheme: Self {										// 2
    Theme(																			// 3
      htmlFactory: OddThemeHTMLFactory(),
      ressourcePaths: []
    )
  }
}
```

1. Hier lege ich fest dass die Website die meine Theme nutzen will auch zu meinem `OddWebsite` Protokoll konform sein muss. Dazu später mehr.
2. Die statische Variable legt auch den Namen der Theme fest, wie man ihn in der Publish Pipeline später nutzt
3. Damit die Theme das HTML "bauen" kann braucht sie natürlich eine HTMLFactory. Interessanter hier sind die `ressourcePaths`, diese sind absichtlich leer bei mir, da der `.head()` component von Publish standardmäßig die `styles.css` im Root-Directory nutzt. Auch dazu später mehr.

### Eigene HTMLFactory

Wirklich viel zu sagen gibt es dazu für meine Seite nicht, da das HTML sehr ähnlich zu dem der 'Foundation' Theme bleibt. Dennoch möchte ich kurz ein paar Worte zu den Funktionen der Factory verlieren und auch kurz, in den Kommentaren, beschreiben was ich denn abgeändert habe.

```swift
private struct OddThemeHTMLFactory<Site: OddWebsite>: HTMLFactory {
  // Erzeugt das HTML für den Index der Seite
  // Nur kleine Änderungen, wie das entfernen eines Paragraphens und Headings
  func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML { /*…*/ }
  
  // Erzeugt das HTML für die einzelnen Sektionen, keine Änderungen
  func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML { /*…*/}

  // Erzeugt das HTML für den Inhalt des Blogs, sprich die .md Dateien 
  // Zeigt zusätzlich das Datum und die Zeit des Artikels an
  func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML { /*…*/ }
  // Erzeugt das HTML für die einzelnen Seite, wie z.B. die "Über mich" Seite
  // Noch keine Änderungen
  func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML { /*…*/ }

  // Erzeugt das HTML für die Tag Liste, eine Übersicht aller Tags
  // Noch keine Änderungen
  func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? { /*…*/ }

  // Erzeugt das HTML für die Tag Details, eine Übersicht aller Posts mit einem Tag
  // Noch keine Änderungen
  func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? { /*…*/ }
}
```

Interessant hierbei ist, dass die letzten beiden Funktionen nicht unbedingt einen Rückgabewert haben müssen. Das ist dann nützlich wenn die Theme die man sich baut keine Tags unterstützen soll. 

Neben diesen Methoden gibt es auch noch Helfer-Structs, `Wrapper` erzeugt einfach nur ein `Div` mit der Klasse 'wrapper', `SiteFooter` erzeugt den Footer, `ItemList` erzeugt eine Liste von allen Posts und `ItemTagList` eine Liste von allen Tags die ein Post hat.

Was ich für meine Theme noch angepasst habe ist der `SiteHeader`, `/*…*/` stehen für Code der unverändert blieb.

```swift
private struct SiteHeader<Site: OddWebsite>: Component {
  var context: PublishingContext<Site>
  var selectedSectionID: Site.SectionID?

  var body: Component {
    Header {
      Wrapper {
        H1( /*…*/ )
        
        // Die Seitenbeschreibung ist nun im Header für meine Theme
        Span(context.site.description).class("description")

        if Site.SectionID.allCases.count > 1 { /*…*/ }

        // Zusätzlich bietet meine Theme nun einen Bereich für "soziale" Links
        // z.B. Github, Twitter, LinkedIn, E-Mail und später vielleicht noch mehr
        socials
      }
    }
  }

  var navigation: Component { /*…*/ }
  
  var socials: Component {
    Navigation {
      List(context.site.contacts) { (contactPoint, handler) in
				Link(url: contactPoint.url(handler)) {
          contactPoint.svg
        }.class("contact-svg")
			}
      .class("share")
    }
  }
}
```

Neu bei der `socials` Komponente ist, dass sie die `contacts` variable meiner Seite nutzt, etwas was durch das `OddWebsite` Protokoll vorgegeben wird.

### Das eigene Protokoll

Durch ein eigenes Protokoll kann man in der Theme dann auch mehr machen, z.B. auf ein Array von Kontaktdaten zugreifen.

```swift
public protocol OddWebsite: Website {
  var contacts: [(ContactPoint, String)] { get }
}

public enum ContactPoint {
  case twitter, github, linkedin, mail
  
  func url(_ handler: String) -> String {
    switch self {
      case .twitter:
      	return "https://twitter.com/\(handler)"
      case .github:
      	return "https://github.com/\(handler)"
      case .linkedin:
      	return "https://www.linkedin.com/in/\(handler)/"
      case .mail:
      	return "mailto:\(handler)"
    }
  }
  
  var svg: Node<HTML.AnchorContext> {
    switch self {
      case .twitter:
      	return .element(/* SVG für das Twitter icon */)
      case .github:
      	return .element(/* SVG für das Github Icon */)
      case .linkedin:
      	return .element(/* SVG für das LinkedIn Icon */)
      case .mail:
      	return .element(/* SVG für das E-Mail Icon */)
    }
  }
}
```

Langfristig will ich die Theme auch als Paket anbieten, dafür muss das Protokoll und auch die Kontaktmöglichkeiten natürlich noch viel erweitert werden. Ich freue mich natürlich über jegliche Hilfe beim Erreichen dieses Ziels.

Damit meine Theme funktioniert brauche ich nun nur noch meine Website Klasse konform dazu machen:

```swift
struct OddmagnetDev: OddWebsite {
  var contacts: [(ContactPoint, String)] {
    [
      (.twitter, "OddMagnetDev"),
      (.github, "OddMagnet"),
      (.linkedin, "OddMagnet"),
      (.mail, "mibruenen@gmail.com")
    ]
  }
  
  /* Die restlichen Variablen die eine Publish-Seite braucht sind ausgelassen */
}

// In der Publish Pipeline muss dann nur noch die eigene Theme genutzt werden
try OddmagnetDev().publish(using: [
  /* andere Schritte ausgelassen */
  .generateHTML(withTheme: .oddTheme),
  /* andere Schritte ausgelassen */
])
```

Im letzten Teil der Reihe werde ich noch kurz über eine kleine Änderung bei den Plugins, sowie das erstellen vom CSS für die Seite gehen.
