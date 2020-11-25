import Foundation
import SwiftSoup

class TopicViewsCountService {
    let source: TopicViewsCountHtmlSource

    init(source: TopicViewsCountHtmlSource) {
        self.source = source
    }

    func get() -> Int64? {
        do {
            let topicHtml: Elements = source.parse()!

            let topicViewsHtml = try topicHtml.select("span.pageviews").first()!

            return try Int64(topicViewsHtml.text())
        } catch {
            return nil
        }
    }
}
