import Foundation

import SwiftSoup

class ArticleCommentsNumberService {
    let source: ArticleCommentsNumberHTMLSource

    init(source: ArticleCommentsNumberHTMLSource) {
        self.source = source
    }

    func get() -> ArticleCommentsNumber? {
        guard let articleCommentsNumberHTML: Element = source.parse() else {
            return nil
        }

        do {
            let articleCommentsNumberText = try articleCommentsNumberHTML.text()
            let articleCommentsNumber = ArticleCommentsNumber(
                number: Int(articleCommentsNumberText.components(separatedBy: " ").first!)!,
                casedWord: articleCommentsNumberText.components(separatedBy: " ").last!
            )
            return articleCommentsNumber
        } catch {
            return nil
        }
    }
}
