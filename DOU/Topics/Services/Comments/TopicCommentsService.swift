import Foundation

import SwiftSoup

class TopicCommentsService {
    let source: ArticleCommentsHtmlSource

    init(source: ArticleCommentsHtmlSource) {
        self.source = source
    }

    func get() -> [TopicComment] {
        var topicComments: [TopicComment] = [TopicComment]()

        guard let topicCommentsHtml: Elements = source.parse() else {
            return topicComments
        }

        for topicCommentHtml in topicCommentsHtml {
            var topicComment = TopicComment()

            if !isCommentHtml(topicCommentHtml: topicCommentHtml) {
                continue
            }

            topicComment.level = getLevel(topicCommentHtml: topicCommentHtml)
            topicComment.authorName = getAuthorName(topicCommentHtml: topicCommentHtml)
            topicComment.publicationDate = getPublicationDate(topicCommentHtml: topicCommentHtml)
            topicComment.authorTitle = getAuthorTitle(topicCommentHtml: topicCommentHtml)
            topicComment.authorCompany = getAuthorCompany(topicCommentHtml: topicCommentHtml)
            topicComment.authorCompanyUrl = getAuthorCompanyUrl(topicCommentHtml: topicCommentHtml)

            let topicCommentAttributedLabel: ArticleCommentAttributedUIView? = getTopicCommentAttributedLabel(
                topicCommentHtml: topicCommentHtml
            )

            if topicCommentAttributedLabel == nil {
                topicComment.uiView = nil
                topicComment.uiViewHeigth = nil
            } else {
                topicComment.uiView = topicCommentAttributedLabel!.get()
                topicComment.uiViewHeigth = topicCommentAttributedLabel!.getHeight(level: topicComment.level)
            }

            topicComments.append(topicComment)
        }

        return topicComments
    }

    private func clearhtmlString(htmlString: String) -> String {
        var htmlString = htmlString

        htmlString = htmlString.replacingOccurrences(
            of: "<div class=\"comment_text b-typo\">\n ",
            with: "<div class=\"comment_text b-typo\">"
        )

        htmlString = htmlString.replacingOccurrences(of: "\n</div>", with: "</div>")

        if htmlString.contains("nobr") {
            htmlString = htmlString.replacingOccurrences(of: "\n  <nobr>\n   ", with: "")
            htmlString = htmlString.replacingOccurrences(of: "\n  </nobr>", with: "")
        }

        if htmlString.contains("p") {
            htmlString = htmlString.replacingOccurrences(of: "</p> \n <p>", with: "</p>\n<p>")
            htmlString = htmlString.replacingOccurrences(of: "\n  <p>", with: "\n<p>")
        }

        if htmlString.contains("br") {
            htmlString = htmlString.replacingOccurrences(of: "<br>", with: "\n")
        }

        if htmlString.contains("<blockquote>") {
            htmlString = htmlString.replacingOccurrences(of: "b-typo\"><blockquote>\n  ", with: "b-typo\"><blockquote>")
            htmlString = htmlString.replacingOccurrences(of: " \n <blockquote>\n  ", with: "<blockquote>\n")
            htmlString = htmlString.replacingOccurrences(of: "\n </blockquote> \n", with: "</blockquote>\n")
            htmlString = htmlString.replacingOccurrences(of: "</blockquote>\n <p", with: "</blockquote>\n<p")
            htmlString = htmlString.replacingOccurrences(of: "\n</p>\n<blockquote>", with: "\n<blockquote>")
            htmlString = htmlString.replacingOccurrences(of: "</p><blockquote>\n ", with: "</p><blockquote>\n")
            htmlString = htmlString.replacingOccurrences(of: "\n</p>\n <blockquote>\n  ", with: "</p>\n<blockquote>")
        }

        return htmlString
    }

    private func isCommentHtml(topicCommentHtml: Element) -> Bool {
        do {
            let topicCommentLevelHtmlClass: String = try topicCommentHtml.attr("class")

            if topicCommentLevelHtmlClass.contains("thread-comments") {
                return false
            }

            if topicCommentLevelHtmlClass.contains("comments-head") {
                return false
            }

            return true
        } catch {
            return false
        }
    }

    private func getLevel(topicCommentHtml: Element) -> CGFloat {
        do {
            let topicCommentLevelHtmlClass: String = try topicCommentHtml.attr("class")

            if let range: Range<String.Index> = topicCommentLevelHtmlClass.range(of: "level-") {
                let levelStartingIndex = String.Index.init(
                    encodedOffset: topicCommentLevelHtmlClass.distance(
                        from: topicCommentLevelHtmlClass.startIndex,
                        to: range.lowerBound
                    ) + "level-".count
                )

                let levelFinishingIndex = String.Index.init(
                    encodedOffset: topicCommentLevelHtmlClass.distance(
                        from: topicCommentLevelHtmlClass.startIndex,
                        to: range.lowerBound
                    ) + "level-".count + 1
                )

                return CGFloat(Int(topicCommentLevelHtmlClass[levelStartingIndex..<levelFinishingIndex])!)
            }
        } catch {
            return 0
        }

        return 0
    }

    private func getTopicCommentAttributedLabel(topicCommentHtml: Element) -> ArticleCommentAttributedUIView? {
        do {
            let topicCommentTextHtml: Element = try topicCommentHtml.getElementsByAttributeValue(
                "class", "comment_text b-typo"
            ).first()!

            let topicCommentTextHtmlString = clearhtmlString(htmlString: topicCommentTextHtml.description)

            let topicCommentAttributedLabel = ArticleCommentAttributedUIView(
                htmlString: topicCommentTextHtmlString
            )

            return topicCommentAttributedLabel
        } catch {
            return nil
        }
    }

    private func getAuthorName(topicCommentHtml: Element) -> String? {
        do {
            let topicCommentAuthorHtml: Element = try topicCommentHtml.select("div.b-post-author").first()!

            let topicCommentAuthorImageHtml: Element = try topicCommentAuthorHtml.getElementsByAttributeValue(
                "class", "avatar"
            ).first()!

            return try topicCommentAuthorImageHtml.text()
        } catch {
            return nil
        }
    }

    private func getPublicationDate(topicCommentHtml: Element) -> Date? {
        do {
            let topicCommentAuthorHtml: Element = try topicCommentHtml.select("div.b-post-author").first()!

            let topicCommentAuthorImageHtml: Element = try topicCommentAuthorHtml.getElementsByAttributeValue(
                "class", "comment-link"
            ).first()!

            let publicationDateAsString: String = try topicCommentAuthorImageHtml.text()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

            let publicationDate = dateFormatter.date(from: publicationDateAsString)
            return publicationDate
        } catch {
            return nil
        }
    }

    private func getAuthorTitle(topicCommentHtml: Element) -> String? {
        do {
            let topicCommentAuthorHtml: Element = try topicCommentHtml.select("div.b-post-author").first()!

            guard let topicCommentAuthorTitleHtml: Element = try topicCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }

            let topicCommentAuthorTitle: String = try topicCommentAuthorTitleHtml.text()

            if topicCommentAuthorTitle.isEmpty {
                return nil
            }

            if let range: Range<String.Index> = topicCommentAuthorTitle.range(of: " в ") {
                let topicCommentAuthorTitleDistanse: Int = topicCommentAuthorTitle.distance(
                    from: topicCommentAuthorTitle.startIndex,
                    to: range.lowerBound
                )

                let authorTitleEndingIndex: String.Index = String.Index(
                    utf16Offset: topicCommentAuthorTitleDistanse,
                    in: topicCommentAuthorTitle
                )

                return String(topicCommentAuthorTitle[..<authorTitleEndingIndex])
            } else {
                return topicCommentAuthorTitle
            }
        } catch {
            return nil
        }
    }

    private func getAuthorCompany(topicCommentHtml: Element) -> String? {
        do {
            let topicCommentAuthorHtml: Element = try topicCommentHtml.select("div.b-post-author").first()!

            guard let topicCommentAuthorTitleHtml: Element = try topicCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }

            let topicCommentAuthorTitle: String = try topicCommentAuthorTitleHtml.text()

            if topicCommentAuthorTitle.isEmpty {
                return nil
            }

            if let range: Range<String.Index> = topicCommentAuthorTitle.range(of: " в ") {
                let topicCommentAuthorTitleDistanse: Int = topicCommentAuthorTitle.distance(
                    from: topicCommentAuthorTitle.startIndex,
                    to: range.lowerBound
                ) + " в ".count

                let authorCompanyStartingIndex: String.Index = String.Index(
                    utf16Offset: topicCommentAuthorTitleDistanse,
                    in: topicCommentAuthorTitle
                )

                return String(topicCommentAuthorTitle[authorCompanyStartingIndex...])
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    private func getAuthorCompanyUrl(topicCommentHtml: Element) -> String? {
        do {
            let topicCommentAuthorHtml: Element = try topicCommentHtml.select("div.b-post-author").first()!

            guard let topicCommentAuthorTitleHtml: Element = try topicCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }

            let topicCommentAuthorTitle: String = try topicCommentAuthorTitleHtml.text()

            if topicCommentAuthorTitle.isEmpty {
                return nil
            }

            do {
                return try topicCommentAuthorTitleHtml.getElementsByTag("a").attr("href")
            } catch {
                return nil
            }
        } catch {
            return nil
        }
    }
}
