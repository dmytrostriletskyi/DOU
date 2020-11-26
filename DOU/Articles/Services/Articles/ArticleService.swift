import Foundation

import Atributika
import SwiftSoup

enum ArticleContentType {
    case text
    case image
}

struct ArticleContent: Identifiable {
    var id = UUID()
    var type: ArticleContentType
    var uiView: AttributedLabel
    var uiViewHeigth: CGFloat
}

class ArticleService {
    let source: ArticleHtmlSource

    private let htmlTagsToEscape: [String] = ["#text"]
    private let textHtmlTags: [String] = ["p", "h1", "h2", "h3", "h4", "h5", "h6"]
    private let unsupportedClasses: [String] = [
        "class=\"b-post-tags\"" // Tags of an article on the DOU website such as article, health, education, etc.
    ]
    private let russianLetters: [Character] = Array(
        "аАбБвВгГдДеЕёЁжЖзЗиИйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ"
    )

    init(source: ArticleHtmlSource) {
        self.source = source
    }

    private func clearHtml(html: String) -> String {
        var html = html

        if html.contains("nobr") {
            html = html.replacingOccurrences(of: "<nobr>", with: "")
            html = html.replacingOccurrences(of: "</nobr>", with: "")
            html = html.replacingOccurrences(of: "\n", with: "")
            html = html.replacingOccurrences(of: "   ", with: "")
        }

        if html.contains("li") {
            html = html.replacingOccurrences(of: "\n", with: "")
        }

        if html.contains("br") {
            html = html.replacingOccurrences(of: "<br>", with: "\n")
        }

        if html.contains("img") {
            html = html.replacingOccurrences(of: "</p>", with: "</img></p>")
        }

        if html.contains("<div class=\"announce-pic\">") {
            html = html.replacingOccurrences(of: "<div class=\"announce-pic\">\n ", with: "<p>")
            html = html.replacingOccurrences(of: "\n</div>", with: "</p>")
            html = html.replacingOccurrences(of: "\n <em>", with: "</img><em>")
        }

        if html.contains("strike") {
            html = html.replacingOccurrences(of: "\n <strike>", with: " <strike>")
            html = html.replacingOccurrences(of: " <strike>\n  ", with: "<strike>")
            html = html.replacingOccurrences(of: "\n </strike>", with: "</strike>")
        }

        if html.contains("blockquote") {
            html = html.replacingOccurrences(of: "<blockquote>\n ", with: "<blockquote>")
            html = html.replacingOccurrences(of: "\n</blockquote>", with: "</blockquote>")
        }

        if html.contains("p") {
            html = html.replacingOccurrences(of: "\n</p>", with: "</p>")
            html = html.replacingOccurrences(of: "<p>\n", with: "<p>")
        }

        if html.contains("<div class=\"hl-wrap") {
            html = html.replacingOccurrences(of: ">\n", with: ">")
        }

        return html
    }

    private func getExceptionalHtmlStrings(html: String) -> [String]? {
        // There may be some exceptions when we want to parse deep and nested HTML strings.
        // For instance, not a <p></p>, but <div><p><a><img></div></p></a></img>.
        let html: String = html

        if html.contains("img") {
            if !html.contains("<p><img") {
                // https://dou.ua/lenta/articles/behavioral-system-design-interview-fb/
                if russianLetters.contains(where: html.contains) {
                    return nil
                }
            }
        }

        return nil
    }

    func get() -> [ArticleContent] {
        var articleContents: [ArticleContent] = [ArticleContent]()

        guard let article: Element = source.parse() else {
            return articleContents
        }

        for articleContentAsHtml in article.getChildNodes() {
            let htmlTag: String = articleContentAsHtml.nodeName()

            if htmlTagsToEscape.contains(htmlTag) {
                continue
            }

            var html: String = articleContentAsHtml.description

            if unsupportedClasses.contains(where: html.contains) {
                continue
            }

            let htmlToProcessDetailed: [String]? = getExceptionalHtmlStrings(html: articleContentAsHtml.description)

            if htmlToProcessDetailed != nil {
                // append separatenly
                // and go to the next iteration
                continue
            }

            html = clearHtml(html: articleContentAsHtml.description)

            if html.contains("img") {
                let imageAttributedLabel = ArticleImageAttributedUIView(html: html)

                articleContents.append(
                    ArticleContent(
                        type: .image,
                        uiView: imageAttributedLabel.get(),
                        uiViewHeigth: imageAttributedLabel.getHeight()
                    )
                )

                continue
            }

            if textHtmlTags.contains(where: html.contains) {
                let textAttributedLabel = ArticleContentAttributedUIView(html: html)

                articleContents.append(
                    ArticleContent(
                        type: .text,
                        uiView: textAttributedLabel.get(),
                        uiViewHeigth: textAttributedLabel.getHeight()
                    )
                )

                continue
            }
        }

        return articleContents
    }
}
