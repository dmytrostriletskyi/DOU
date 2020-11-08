import Foundation
import SwiftUI

import Atributika
import SwiftSoup

enum HtmlParserIdentifier {
    case id
    case class_
}

class ArticleCommentsHtmlSource {
    let html: String
    let rootTag: String
    let identifier: HtmlParserIdentifier

    init(html: String, rootTag: String, identifier: HtmlParserIdentifier) {
        self.html = html
        self.rootTag = rootTag
        self.identifier = identifier
    }

    func parse() -> Elements? {
        do {
            let document: Document = try SwiftSoup.parse(html)

            if identifier == .id {
                let articleComments: Element? = try document.getElementById(rootTag)

                if articleComments != nil {
                    return articleComments!.children()
                }
            }

            if identifier == .class_ {
                let articleComments: Element? = try document.getElementsByClass(rootTag).first()

                if articleComments != nil {
                    return articleComments!.children()
                }
            }

            return nil
        } catch Exception.Error(_, let message) {
            print("Error during getting article comments from HTML: \(message).")
            return nil
        } catch {
            print("Unknown error during getting article comments from HTML.")
            return nil
        }
    }
}
