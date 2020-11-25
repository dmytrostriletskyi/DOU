import Foundation
import SwiftSoup

class TopicService {
    let source = TopicHtmlSource(html: html)

    func get(html: String) -> Int64? {
        let topicHtml: Elements = parse(html: html)!

        return self.getViews(topicHtml: topicHtml)
    }

    func getViews(topicHtml: Elements) -> Int64? {
        do {
            let topicViewsHtml = try topicHtml.select("span.pageviews").first()!

            return try Int64(topicViewsHtml.text())
        } catch {
            return nil
        }
    }
}
