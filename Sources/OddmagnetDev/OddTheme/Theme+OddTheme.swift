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
            .oddHead(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSectionID: nil)
                Wrapper {
                    H1(index.title)

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
            .oddHead(for: section, on: context.site),
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
            .oddHead(for: item, on: context.site),
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
                .oddHead(for: page, on: context.site),
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
            .oddHead(for: page, on: context.site),
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
            .oddHead(for: page, on: context.site),
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

private extension Node where Context == HTML.DocumentContext {
    /// Add an HTML `<head>` tag within the current context, based
    /// on inferred information from the current location and `Website`
    /// implementation.
    /// - parameter location: The location to generate a `<head>` tag for.
    /// - parameter site: The website on which the location is located.
    /// - parameter titleSeparator: Any string to use to separate the location's
    ///   title from the name of the website. Default: `" | "`.
    /// - parameter stylesheetPaths: The paths to any stylesheets to add to
    ///   the resulting HTML page. Default: `styles.css`.
    /// - parameter rssFeedPath: The path to any RSS feed to associate with the
    ///   resulting HTML page. Default: `feed.rss`.
    /// - parameter rssFeedTitle: An optional title for the page's RSS feed.
    static func oddHead<T: OddWebsite>(
        for location: Location,
        on site: T,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css", "/gallery.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil
    ) -> Node {
        var title = location.title

        if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }

        var description = location.description

        if description.isEmpty {
            description = site.description
        }

        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .forEach(stylesheetPaths, { .stylesheet($0) }),
            .viewport(.accordingToDevice),
//            .unwrap(site.favicon, { .favicon($0) }),
            .oddFavicons(basePath: site.faviconBasePath ?? "/images/favicons/"),
            .unwrap(rssFeedPath, { path in
                let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                return .rssFeedLink(path.absoluteString, title: title)
            }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            })
        )
    }
}

private extension Node where Context == HTML.HeadContext {
    /// Declare a "favicon" (a small icon typically displayed along the website's
    /// title in various browser UIs) for the HTML page.
    /// - parameter url: The favicon's URL.
    /// - parameter type: The MIME type of the image (default: "image/png").
    static func oddFavicons(basePath: String) -> Node {
        .group([
            .link(
                .rel(.appleTouchIcon),
                .attribute(named: "sizes", value: "180x180"),
                .href(basePath.appending("apple-touch-icon.png"))
            ),
            .link(
                .rel(.icon),
                .type("image/png"),
                .attribute(named: "sizes", value: "32x32"),
                .href(basePath.appending("favicon-32x32.png"))
            ),
            .link(
                .rel(.icon),
                .type("image/png"),
                .attribute(named: "sizes", value: "16x16"),
                .href(basePath.appending("favicon-16x16.png"))
            ),
            .link(
                .rel(.manifest),
                .href(basePath.appending("site.webmanifest"))
            ),
            .link(
                .rel(.maskIcon),
                .href(basePath.appending("safari-pinned-tab.svg")),
                .attribute(named: "content", value: "#d0d0d0")
            ),
            .meta(
                .name("msapplication-TileColor"),
                .content("d0d0d0")
            ),
            .meta(
                .name("theme-color"),
                .content("d0d0d0")
            )
        ])
    }
}
