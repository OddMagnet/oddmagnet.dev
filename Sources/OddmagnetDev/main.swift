import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct OddmagnetDev: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://oddmagnet.dev")!
    var name = "OddMagnet's Swift Blog"
    var description = "Eine deutschsprachige Webseite rund um die Programmiersprache Swift"
    var language: Language { .german }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try OddmagnetDev().publish(using: [
    .copyResources(),
    .sortItems(by: \.date),
    .generateHTML(withTheme: .foundation),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("OddMagnet/oddmagnet.dev"))
])
