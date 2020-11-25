import Foundation

import SwiftSoup

class TopicHtmlSource {
    let html: String

    init(html: String) {
        self.html = html
    }

    func parse() -> Elements? {
        do {
            let document: Document = try SwiftSoup.parse(html)
            return try document.getElementsByClass("b-forum-articles").first()!.children()
        } catch Exception.Error(_, let message) {
            print("Error during getting article from HTML: \(message).")
            return nil
        } catch {
            print("Unknown error during getting article from HTML.")
            return nil
        }
    }
}
