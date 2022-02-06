import Foundation
import Publish
import Plot
// Plugins
import SyntaxHighlightPublishPlugin
//import SplashPublishPlugin // removing Splash since it also highlights shell code
import SassPublishPlugin

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

    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case projects
        case aboutme
        case cv
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        // Uses the metadata from the markdown files
        let tags: [Tag]
        let description: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://oddmagnet.dev")!
    var name = "OddMagnet.dev"
    var description = "Eine deutschsprachige Webseite rund um die Programmiersprache Swift"
    var language: Language { .german }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try OddmagnetDev().publish(using: [
    // TODO: add plugins, e.g. Splash
    .installPlugin(.syntaxHighlighting([.swift])),
//    .installPlugin(.splash(withClassPrefix: "")), // removing Splash since it also highlights shell code
    .addMarkdownFiles(),
    .installPlugin(
        .compileSass(
            sassFilePath: "Resources/OddTheme/sass/styles.sass",
            cssFilePath: "styles.css"
        )
    ),
    .copyResources(),
    .sortItems(in: .posts, by: \.date, order: .descending),
    // TODO: add custom theme
    .generateHTML(withTheme: .oddTheme),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("OddMagnet/oddmagnet.dev", branch: "main"))
])
