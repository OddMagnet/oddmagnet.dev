/**
 *  Publish
 *  Copyright (c) John Sundell 2019
 *  MIT license, see LICENSE file for details
 */

import Publish
import Plot

public extension Theme {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var oddTheme: Self {
        Theme(
            htmlFactory: OddThemeHTMLFactory(),
            resourcePaths: []
        )
    }
}

private struct OddThemeHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: nil)
                Wrapper {
                    H1("IndexHTML " + index.title)
                    Paragraph(context.site.description)
//                        .class("description")
                    // TODO: Add Projects here
                    H2("Aktuelle Blogposts")
                    // TODO: Add ItemList()
                }
                // TODO: Add SiteFooter()
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

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSectionID: Site.SectionID?

    var body: Component {
        Header {
            Div {
                Div {
                    H1(
                        Link(context.site.name, url: "/")
                    )
                    Span(context.site.description).class("description")
                }.id("blog-title")

                navigation
            }.id("blog-header")
        }
    }

    var navigation: Component {
        Navigation {
            List {
                // MARK: Socials
                // TODO: Use icons instead of text, maybe add LinkedIn as well
                Link(
                    "Twitter",
                    url: "https://twitter.com/OddMagnetDev"
                )
                Link(
                    "Github",
                    url: "https://github.com/OddMagnet"
                )
                Link(
                    "E-Mail",
                    url: "mailto:mibruenen@gmail.com"
                )
            }
            .class("share")

            if Site.SectionID.allCases.count > 1 {
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
    }
}
