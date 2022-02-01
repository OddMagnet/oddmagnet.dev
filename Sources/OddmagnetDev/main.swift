import Foundation
import Publish
import Plot
// Plugins
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct OddmagnetDev: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case projects
        case aboutme
        case cv
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
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
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .copyResources(),
    .sortItems(by: \.date),
    // TODO: add custom theme
    .generateHTML(withTheme: .oddTheme),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("OddMagnet/oddmagnet.dev", branch: "main"))
])
