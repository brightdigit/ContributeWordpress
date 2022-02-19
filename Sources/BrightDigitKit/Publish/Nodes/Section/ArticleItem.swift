import Foundation
import Plot
import Publish

struct ArticleItem: SectionItem {
  let slug: String
  let description: String
  let featuredImageURL: URL
  let title: String
  let publishedDate: Date
  let source: Item<BrightDigitSite>

  let isFeatured: Bool

  var featuredItemContent: [Node<HTML.BodyContext>] {
    [
      .header(
        .img(.src(featuredImageURL))
      ),
      .main(
        .header(
          .a(
            .h2(.text(title)),
            .href(slug)
          )
        ),
        .main(
          .text(description)
        ),
        .footer(
          " published on ",
          .span(
            .class("published-date"),
            .text(PiHTMLFactory.itemFormatter.string(from: publishedDate))
          )
        )
      )
    ]
  }

  var sectionItemContent: [Node<HTML.BodyContext>] {
    [
      .id("post-\(slug)"),
      .header(
        .img(.src(featuredImageURL)),
        .a(
          .h2(.text(title))
        )
      ),
      .main(
        .text(description)
      ),
      .footer(
        .a(
          .text(PiHTMLFactory.itemFormatter.string(from: publishedDate))
        )
      )
    ]
  }

  var pageTitle: String {
    title
  }

  var pageBodyID: String? {
    nil
  }

  var pageMainContent: [Node<HTML.BodyContext>] {
    [.contentBody(source.body)]
  }

  init(item: Item<BrightDigitSite>) throws {
    source = item
    let featuredImageURL = item.metadata.featuredImage.flatMap(URL.init(string:))
    let isFeatured = item.metadata.featured ?? false

    guard let featuredImageURL = featuredImageURL else {
      throw PiError.missingField(MissingFields.ArticleField.featuredImageURL, item)
    }

    slug = item.path.string
    title = item.title
    description = item.description
    self.featuredImageURL = featuredImageURL
    publishedDate = item.metadata.date
    self.isFeatured = isFeatured
  }
}
