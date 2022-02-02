/**
 *  Publish
 *  Copyright (c) John Sundell 2019
 *  MIT license, see LICENSE file for details
 */

import Publish
import Plot

public extension Theme where Site: OddWebsite {
    static var oddTheme: Self {
        Theme(
            htmlFactory: OddThemeHTMLFactory(),
            resourcePaths: []
        )
    }
}

private struct OddThemeHTMLFactory<Site: OddWebsite>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: nil)
                Wrapper {
                    H1(index.title)

                    // TODO: Projekte hier nochmal zeigen? Oder reicht in der Navigation?
//                    ItemList()
                }
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("SectionHTML")
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("ItemHTML")
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML("PageHTML")
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML("TagListHTML")
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML("TagDetailsHTML")
    }

}

// MARK: - Components
private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: OddWebsite>: Component {
    var context: PublishingContext<Site>
    var selectedSectionID: Site.SectionID?

    var body: Component {
        Header {
            Wrapper {
                H1(
                    Link(context.site.name, url: "/")
                        .class("site-name")
                )

                Span(context.site.description).class("description")

                if Site.SectionID.allCases.count > 1 {
                    navigation
                }

                socials
            }
        }
    }

    var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(
                    section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSectionID ? "selected" : "")
            }
            .class("menu")
        }
    }

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

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Paragraph {
                Text("In Swift mit ")
                Link("Publish", url: "https://github.com/johnsundell/publish")
                Text(" erstellt")
            }
            Paragraph {
                Link("RSS feed", url: "/feed.rss")
            }
        }
    }
}
