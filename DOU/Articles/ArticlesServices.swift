import Foundation

import SwiftSoup

class ArticleComments {

    public let htmlParser: ArticleCommentsHtmlParser

    init(htmlParser: ArticleCommentsHtmlParser) {
        self.htmlParser = htmlParser
    }
    
    public func get() -> [ArticleComment] {
        var articleComments: [ArticleComment] = [ArticleComment]()
        
        guard let articleCommentsHtml: Elements = htmlParser.parse() else {
            return articleComments
        }

        for articleCommentHtml in articleCommentsHtml {
            var articleComment: ArticleComment = ArticleComment()

            if !isCommentHtml(articleCommentHtml: articleCommentHtml) {
                continue
            }

            articleComment.level = getLevel(articleCommentHtml: articleCommentHtml)
            articleComment.authorName = getAuthorName(articleCommentHtml: articleCommentHtml)
            articleComment.publicationDate = getPublicationDate(articleCommentHtml: articleCommentHtml)
            articleComment.authorTitle = getAuthorTitle(articleCommentHtml: articleCommentHtml)
            articleComment.authorCompany = getAuthorCompany(articleCommentHtml: articleCommentHtml)
            articleComment.authorCompanyUrl = getAuthorCompanyUrl(articleCommentHtml: articleCommentHtml)

            let articleCommentAttributedLabel: ArticleCommentAttributedLabel? = getArticleCommentAttributedLabel(
                articleCommentHtml: articleCommentHtml
            )

            if articleCommentAttributedLabel == nil {
                articleComment.uiView = nil
                articleComment.uiViewHeigth = nil

            } else {
                articleComment.uiView = articleCommentAttributedLabel!.get()
                articleComment.uiViewHeigth = articleCommentAttributedLabel!.getHeight(level: articleComment.level)
            }
            
            articleComments.append(articleComment)
        }

        return articleComments
    }

    private func clearhtmlString(htmlString: String) -> String {
        var htmlString = htmlString

        htmlString = htmlString.replacingOccurrences(of: "<div class=\"comment_text b-typo\">\n ", with: "<div class=\"comment_text b-typo\">")
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
    
    private func isCommentHtml(articleCommentHtml: Element) -> Bool {
        do {
            let articleCommentLevelHtmlClass: String = try articleCommentHtml.attr("class")
            
            if articleCommentLevelHtmlClass.contains("thread-comments") {
                return false
            }
            
            if articleCommentLevelHtmlClass.contains("comments-head") {
                return false
            }
            
            return true
            
        } catch {
            return false
        }
    }
    
    private func getLevel(articleCommentHtml: Element) -> CGFloat {
        do {
            let articleCommentLevelHtmlClass: String = try articleCommentHtml.attr("class")
            
            if let range: Range<String.Index> = articleCommentLevelHtmlClass.range(of: "level-") {
                let levelStartingIndex = String.Index.init(
                    encodedOffset: articleCommentLevelHtmlClass.distance(
                        from: articleCommentLevelHtmlClass.startIndex,
                        to: range.lowerBound
                    ) + "level-".count
                )
                
                let levelFinishingIndex = String.Index.init(
                    encodedOffset: articleCommentLevelHtmlClass.distance(
                        from: articleCommentLevelHtmlClass.startIndex,
                        to: range.lowerBound
                    ) + "level-".count + 1
                )
                
                return CGFloat(Int(articleCommentLevelHtmlClass[levelStartingIndex..<levelFinishingIndex])!)
            }

        } catch {
            return 0
        }

        return 0
    }
    
    private func getArticleCommentAttributedLabel(articleCommentHtml: Element) -> ArticleCommentAttributedLabel? {
        do {
            let articleCommentTextHtml: Element = try articleCommentHtml.getElementsByAttributeValue(
                "class", "comment_text b-typo"
            ).first()!
            
            let articleCommentTextHtmlString = clearhtmlString(htmlString: articleCommentTextHtml.description)
            
            let articleCommentAttributedLabel: ArticleCommentAttributedLabel = ArticleCommentAttributedLabel(
                htmlString: articleCommentTextHtmlString
            )
            
            return articleCommentAttributedLabel
            
        } catch {
            return nil
        }
    }

    private func getAuthorName(articleCommentHtml: Element) -> String? {
        do {
            let articleCommentAuthorHtml: Element = try articleCommentHtml.select("div.b-post-author").first()!
            
            let articleCommentAuthorImageHtml: Element = try articleCommentAuthorHtml.getElementsByAttributeValue(
                "class", "avatar"
            ).first()!

            return try articleCommentAuthorImageHtml.text()

        } catch {
            return nil
        }
    }

    private func getPublicationDate(articleCommentHtml: Element) -> Date? {
        do {
            let articleCommentAuthorHtml: Element = try articleCommentHtml.select("div.b-post-author").first()!

            let articleCommentAuthorImageHtml: Element = try articleCommentAuthorHtml.getElementsByAttributeValue(
                "class", "comment-link"
            ).first()!
            
            let publicationDateAsString: String = try articleCommentAuthorImageHtml.text()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            
            let publicationDate = dateFormatter.date(from: publicationDateAsString)
            return publicationDate

        } catch {
            return nil
        }
    }
    
    private func getAuthorTitle(articleCommentHtml: Element) -> String? {
        do {
            let articleCommentAuthorHtml: Element = try articleCommentHtml.select("div.b-post-author").first()!

            guard let articleCommentAuthorTitleHtml: Element = try articleCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }
            
            let articleCommentAuthorTitle: String = try articleCommentAuthorTitleHtml.text()
            
            if articleCommentAuthorTitle.isEmpty {
                return nil
            }

            if let range: Range<String.Index> = articleCommentAuthorTitle.range(of: " в ") {
                let articleCommentAuthorTitleDistanse: Int = articleCommentAuthorTitle.distance(
                    from: articleCommentAuthorTitle.startIndex,
                    to: range.lowerBound
                )
                
                let authorTitleEndingIndex: String.Index = String.Index(
                    utf16Offset: articleCommentAuthorTitleDistanse,
                    in: articleCommentAuthorTitle
                )

                return String(articleCommentAuthorTitle[..<authorTitleEndingIndex])

            } else {
                return articleCommentAuthorTitle
            }

        } catch {
            return nil
        }
    }
    
    private func getAuthorCompany(articleCommentHtml: Element) -> String? {
        do {
            let articleCommentAuthorHtml: Element = try articleCommentHtml.select("div.b-post-author").first()!
            
            guard let articleCommentAuthorTitleHtml: Element = try articleCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }
            
            let articleCommentAuthorTitle: String = try articleCommentAuthorTitleHtml.text()

            if articleCommentAuthorTitle.isEmpty {
                return nil
            }

            if let range: Range<String.Index> = articleCommentAuthorTitle.range(of: " в ") {
                let articleCommentAuthorTitleDistanse: Int = articleCommentAuthorTitle.distance(
                    from: articleCommentAuthorTitle.startIndex,
                    to: range.lowerBound
                ) + " в ".count
                
                let authorCompanyStartingIndex: String.Index = String.Index(
                    utf16Offset: articleCommentAuthorTitleDistanse,
                    in: articleCommentAuthorTitle
                )
                
                return String(articleCommentAuthorTitle[authorCompanyStartingIndex...])

            } else {
                return nil
            }

        } catch {
            return nil
        }
    }
    
    private func getAuthorCompanyUrl(articleCommentHtml: Element) -> String? {
        do {
            let articleCommentAuthorHtml: Element = try articleCommentHtml.select("div.b-post-author").first()!
            
            guard let articleCommentAuthorTitleHtml: Element = try articleCommentAuthorHtml.getElementsByAttributeValue(
                "class", "prof"
            ).first() else {
                return nil
            }
            
            let articleCommentAuthorTitle: String = try articleCommentAuthorTitleHtml.text()
            
            if articleCommentAuthorTitle.isEmpty {
                return nil
            }

            do {
                return try articleCommentAuthorTitleHtml.getElementsByTag("a").attr("href")
            } catch {
                return nil
            }

        } catch {
            return nil
        }
    }
}
