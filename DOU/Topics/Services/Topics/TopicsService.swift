import Foundation

import SwiftSoup

class TopicsService {
    
    private var currentFetchingPage: Int = 1

    public func get(
        page: Int = 1,
        completion: @escaping ([Topic]) -> Void
    ) {
        Html(url: "https://dou.ua/forums/latest/page/\(page)").get() { html in
            var topics: [Topic] = [Topic]()
            
            guard let html = html else {
                return
            }

            let source = TopicHtmlSource(html: html)

            guard let topicsHtml: Elements = source.parse() else {
                return
            }

            for topicHtml in topicsHtml {
                var topic: Topic = Topic()
                topic.authorName = self.getAuthorName(topicHtml: topicHtml)
                topic.link = self.getLink(topicHtml: topicHtml)
                topic.title = self.getTitle(topicHtml: topicHtml)
                topic.type = self.getType(topicHtml: topicHtml)
                topic.subject = self.getSubject(topicHtml: topicHtml)
                topic.commentsCount = self.getCommentsCount(topicHtml: topicHtml)
                topic.publicationDate = self.getPublicationDate(topicHtml: topicHtml)
                
                topics.append(topic)
            }
            completion(topics)
        }
    }

    public func getNext(completion: @escaping ([Topic]) -> Void) {
        currentFetchingPage += 1
        get(page: currentFetchingPage, completion: completion)
        
    }

    private func getAuthorName(topicHtml: Element) -> String? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("div.info").first()!

            let topicAuthorImageHtml: Element = try topicAuthorHtml.getElementsByAttributeValue(
                "class", "author"
            ).first()!

            return try topicAuthorImageHtml.text()

        } catch {
            return nil
        }
    }
    
    private func getPublicationDate(topicHtml: Element) -> Date? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("div.info").first()!

            let topicAuthorImageHtml: Element = try topicAuthorHtml.getElementsByAttributeValue(
                "class", "date"
            ).first()!
            
            let publicationDateAsString: String = try topicAuthorImageHtml.text()
                        
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru")
            formatter.dateFormat = "dd MM yyyy"
            formatter.timeZone = TimeZone(secondsFromGMT: 2)
            
            let publicationDate: Date = formatter.date(from: publicationDateAsString)!

            return publicationDate

        } catch {
            return nil
        }
    }
    
    private func getTitle(topicHtml: Element) -> String? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("h2").first()!

            guard let topicAuthorTitleHtml: Element = try topicAuthorHtml.getElementsByTag("a").first() else {
                return nil
            }
            
            return try topicAuthorTitleHtml.text()
        
        } catch {
            return nil
        }
    }
    
    private func getType(topicHtml: Element) -> String? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("div.more").first()!

            let topicTypeHtml: Element = try topicAuthorHtml.getElementsByAttributeValue(
                "class", "topic"
            ).first()!

            return try topicTypeHtml.text()

        } catch {
            return nil
        }
    }
    
    private func getSubject(topicHtml: Element) -> String? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("div.more").first()!
            
            let topicTypeHtml: Element = try topicAuthorHtml.select("a[href]").first()!
            
            var topicSubjectHtml: String = ""
            
            for topicSubject in try topicAuthorHtml.select("a[href]") {
            
                var topicSubject: String = try topicSubject.text()
                
                if try topicTypeHtml.text() != topicSubject {
                    topicSubject = topicSubjectHtml + "\(topicSubject), "
                    topicSubjectHtml = topicSubject
                }
            }
            
            if topicSubjectHtml == "" {
                return topicSubjectHtml
            }
            
            topicSubjectHtml.removeLast(2)
            return topicSubjectHtml

        } catch {
            return nil
        }
    }
    
    private func getCommentsCount(topicHtml: Element) -> Int64? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("h2 a").last()!
            
            let topicCommentsCount = try topicAuthorHtml.text()
            
            if Int64(topicCommentsCount) != nil {
                return Int64(topicCommentsCount)
            } else {
                return 0
            }
        } catch {
            return nil
        }
    }
    
    private func getLink(topicHtml: Element) -> String? {
        do {
            let topicAuthorHtml: Element = try topicHtml.select("h2 a").first()!
            let topicLink: String = try topicAuthorHtml.attr("href")
                        
            return topicLink
            
        } catch {
            return nil
        }
    }
    
}
