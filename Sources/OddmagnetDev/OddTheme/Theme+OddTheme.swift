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
                H1("IndexHTML")
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
