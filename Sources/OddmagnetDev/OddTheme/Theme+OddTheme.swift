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
                        .class("index-title")

                    // TODO: Aktuelle Projekte hier nochmal zeigen? Oder reicht in der Navigation?

                    // TODO: Tag-list wie bei swiftunwrap.com

                    ItemList(
                        items: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: section.id)
                Wrapper {
                    ItemList(items: section.items, site: context.site)
                }
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    SiteHeader(context: context, selectedSectionID: item.sectionID)
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Div {
                                if #available(macOS 12.0, *) {
                                    Span("Zuletzt bearbeitet: \(item.lastModified.formatted(date: .abbreviated, time: .shortened))")
                                }
                                Span {
                                    Text("Markiert mit: ")
                                    ItemTagList(item: item, site: context.site)
                                }
                            }
                            .class("content-info")
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        // get the current path, drop the '/', transformt the Substring back into a normal String
        let pathString = String(page.path.absoluteString.dropFirst(1))
        // transform the pathString into a SectionID, so it can be passed to `SiteHeader`
        let selectedSectionID = Site.SectionID(rawValue: pathString)

        // "Lebenslauf" (cv) gets special page treatment
        if pathString != "lebenslauf" {
            return HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site),
                .body(
                    .class("single-page"),
                    .components {
                        SiteHeader(
                            context: context,
                            selectedSectionID: selectedSectionID
                        )
                        Wrapper {
                            Article {
                                Div(page.body).class("content")
                            }
                        }
                        SiteFooter()
                    }
                )
            )
        } else {
            return HTML(
                .lang(context.site.language),
                .head(
                    .meta(.attribute(named: "charset", value: "utf-8")),
                    .title("\(page.title) | CV"),
                    .link(
                        .href("../cv-css/davewhipp-print.css"),
                        .type("text/css"),
                        .rel(.stylesheet),
                        .attribute(named: "media", value: "print")
                    ),
                    .link(
                        .href("../cv-css/davewhipp-screen.css"),
                        .type("text/css"),
                        .rel(.stylesheet),
                        .attribute(named: "media", value: "screen")
                    )
                    /*
                     <head>
                     <meta charset="utf-8">
                     <title>  Michael Brünen's Lebenslauf |  CV</title>
                     <link href="media/davewhipp-screen.css" type="text/css" rel="stylesheet" media="screen">
                     <link href="media/davewhipp-print.css" type="text/css" rel="stylesheet" media="print">
                     </head>
                     */
                ),
                .body(
                    .components {
                        Div(page.body).class("cv")
                    }
                )
            )
        }
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: nil)
                Wrapper {
                    H1("Alle Markierungen durchsuchen")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(
                                tag.string,
                                url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag \(tag.string.lowercased())")
                    }
                    .class("all-tags")
                }
                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: nil)
                Wrapper {
                    H1 {
                        Text("Markiert mit ")
                        Span(page.tag.string)
                            .class("tag \(page.tag.string.lowercased())")
                    }

                    Link(
                        "Alle Markierungen durchsuchen",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
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

                return ListItem {
                    Link(
                        section.title,
                        url: section.path.absoluteString
                    )
                }
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

private struct ItemList<Site: OddWebsite>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            ListItem {
                Article {
                    H1(Link(item.title, url: item.path.absoluteString))
                    ItemTagList(item: item, site: site)
                    Paragraph(item.description)
                }
            }.class("item")
        }
        .class("item-list")
    }
}

private struct ItemTagList<Site: OddWebsite>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            ListItem {
                Link(tag.string, url: site.path(for: tag).absoluteString)
            }
            .class("tag \(tag.string.lowercased())")
        }
        .class("tag-list")
    }
}
