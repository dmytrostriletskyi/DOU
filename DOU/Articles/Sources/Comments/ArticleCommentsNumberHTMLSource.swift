import Foundation

import SwiftSoup

class ArticleCommentsNumberHTMLSource {
    let html: String
    let rootTag: String
    let identifier: HtmlParserIdentifier

    init(html: String, rootTag: String, identifier: HtmlParserIdentifier) {
        self.html = html
        self.rootTag = rootTag
        self.identifier = identifier
    }

    func parse() -> Element? {
        let article: Element

        do {
            let document: Document = try SwiftSoup.parse(html)
            article = try document.getElementById(rootTag)!
        } catch Exception.Error(_, let message) {
            print("Error during getting article from HTML: \(message).")
            return nil
        } catch {
            print("Unknown error during getting article from HTML.")
            return nil
        }

        return article
    }
}
