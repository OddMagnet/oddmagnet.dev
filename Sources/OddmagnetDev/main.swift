import Foundation
import Publish
import Plot
// Plugins
import SyntaxHighlightPublishPlugin
import SassPublishPlugin
import SVGPublishPlugin
import MinifyCSSPublishPlugin
import PublishGallery

// This type acts as the configuration for your website.
struct OddmagnetDev: OddWebsite {
    var contacts: [(ContactPoint, String)] {
        [
            (.twitter, "OddMagnetDev"),
            (.github, "OddMagnet"),
            (.linkedin, "OddMagnet"),
            (.mail, "mibruenen@gmail.com")
        ]
    }
    var faviconBasePath: String?

    enum SectionID: String, WebsiteSectionID {
        // Only single-pages need an assigned raw value
        // sections use the title of their `index.md` file
        // for single-pages the raw-value is used
        case posts
        case projects
        case über
        case photos
        case lebenslauf
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        // Uses the metadata from the markdown files
        let tags: [Tag]
        let description: String
        let date: Date
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://oddmagnet.dev")!
    var name = "OddMagnet.dev"
    var description = "Eine deutschsprachige Webseite rund um die Programmiersprache Swift"
    var language: Language { .german }
    var imagePath: Path? { "images" }
}

// This will generate your website using the built-in Foundation theme:
try OddmagnetDev().publish(using: [
    // TODO: finetune plugins. Think about Syntax Highlighting plugins
    .installPlugin(.syntaxHighlighting([.swift])),
    .installPlugin(.publishGallery()),
//    .installPlugin(.splash(withClassPrefix: "")), // removing Splash since it also highlights shell code
    .addMarkdownFiles(),
    .installPlugin(
        .compileSass(
            sassFilePath: "Resources/OddTheme/sass/styles.sass",
            cssFilePath: "styles.css"
        )
    ),
    .copyResources(),
    .installPlugin(.svgPlugin()),
    .sortItems(in: .posts, by: \.date, order: .descending),
    // The `styles.css` file is not put into the Ressource-paths of the theme, since
    // the next step would then try to copy it from the 'Resources' folder, but the
    // Gallery plugin by default already puts the CSS file in the 'Output' folder
    // TODO: make a pull request to update the plugin
    .generateHTML(withTheme: .oddTheme),
    .installPlugin(.minifyCSS()),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("OddMagnet/oddmagnet.dev", branch: "main"))
])
