import Foundation

import SwiftSoup
import Atributika

enum HtmlStringType {
    case text
    case image
}

struct HtmlString: Identifiable {

    var id: UUID = UUID()
    var type: HtmlStringType
    var uiView: AttributedLabel
    var uiViewHeigth: CGFloat
}

class ArticlesHtmlParser {
    
    public let html: String
    public let rootTag: String
    
    private let htmlTagsToEscape: [String] = ["#text"]
    private let textHtmlTags: [String] = ["p", "h1", "h2", "h3", "h4", "h5", "h6"]
    private let unsupportedClasses: [String] = ["class=\"b-post-tags\""]
    private let russianLetters: [Character] = Array("аАбБвВгГдДеЕёЁжЖзЗиИйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ")
    
    init(html: String, rootTag: String) {
        self.html = html
        self.rootTag = rootTag
    }
    
    private func getArticle() -> Element? {
        let article: Element
        
        do {
            let document: Document = try SwiftSoup.parse(html)
            article = try document.select(rootTag).first()!

        } catch Exception.Error(_, let message) {
            print("Error during getting article from HTML: \(message).")
            return nil

        } catch {
            print("Unknown error during getting article from HTML.")
            return nil
        }

        return article
    }
    
    private func clearhtmlString(htmlString: String) -> String {
        var htmlString = htmlString

        if htmlString.contains("nobr") {
            htmlString = htmlString.replacingOccurrences(of: "<nobr>", with: "")
            htmlString = htmlString.replacingOccurrences(of: "</nobr>", with: "")
            htmlString = htmlString.replacingOccurrences(of: "\n", with: "")
            htmlString = htmlString.replacingOccurrences(of: "   ", with: "")
        }
        
        if htmlString.contains("li") {
            htmlString = htmlString.replacingOccurrences(of: "\n", with: "")
        }

        if htmlString.contains("img") {
            htmlString = htmlString.replacingOccurrences(of: "</p>", with: "</img></p>")
        }
        
        if htmlString.contains("<div class=\"announce-pic\">") {
            htmlString = htmlString.replacingOccurrences(of: "<div class=\"announce-pic\">\n ", with: "<p>")
            htmlString = htmlString.replacingOccurrences(of: "\n</div>", with: "</p>")
            htmlString = htmlString.replacingOccurrences(of: "\n <em>", with: "</img><em>")
        }
        
        if htmlString.contains("strike") {
            htmlString = htmlString.replacingOccurrences(of: "\n <strike>", with: " <strike>")
            htmlString = htmlString.replacingOccurrences(of: " <strike>\n  ", with: "<strike>")
            htmlString = htmlString.replacingOccurrences(of: "\n </strike>", with: "</strike>")
            
        }
        
        return htmlString
    }

    private func getExceptionalHtmlStrings(htmlString: String) -> [String]? {
        let htmlString: String = htmlString

        if htmlString.contains("img") {
            
            if !htmlString.contains("<p><img") {
                // https://dou.ua/lenta/articles/behavioral-system-design-interview-fb/
                if russianLetters.contains(where: htmlString.contains) {
                    return nil
                }
            }
        }
        
        return nil
    }
    public func parse() -> [HtmlString]? {
        guard let article: Element = getArticle() else {
            return nil
        }
        
        var htmlStrings: [HtmlString] = [HtmlString]()
        
        for childNode in article.getChildNodes() {
            let htmlStringTagName: String = childNode.nodeName()
            
            if htmlTagsToEscape.contains(htmlStringTagName) {
                continue
            }
            
            var htmlString: String = childNode.description
            
            if unsupportedClasses.contains(where: htmlString.contains) {
                continue
            }
            
            let htmlStringsToPRocessSeparately: [String]? = getExceptionalHtmlStrings(htmlString: childNode.description)
            
            if htmlStringsToPRocessSeparately != nil {
                // append separatenly
                // and go to the next iteration
                continue
            }

            htmlString = clearhtmlString(htmlString: childNode.description)

            if htmlString.contains("img") {
                let imageAttributedLabel: ImageAttributedLabel = ImageAttributedLabel(htmlString: htmlString)

                htmlStrings.append(HtmlString(
                    type: .image,
                    uiView: imageAttributedLabel.get(),
                    uiViewHeigth: imageAttributedLabel.getHeight()
                ))
                
                continue
            }
            
            if textHtmlTags.contains(where: htmlString.contains) {
                let textAttributedLabel: TextAttributedLabel = TextAttributedLabel(htmlString: htmlString)

                htmlStrings.append(HtmlString(
                    type: .text,
                    uiView: textAttributedLabel.get(),
                    uiViewHeigth: textAttributedLabel.getHeight()
                ))
                
                continue
            }
        }

        return htmlStrings
    }
}

enum HtmlParserIdentifier {
    case id
    case class_
}

class ArticleCommentsHtmlParser {
    public let html: String
    public let rootTag: String
    public let identifier: HtmlParserIdentifier
    
    init(html: String, rootTag: String, identifier: HtmlParserIdentifier) {
        self.html = html
        self.rootTag = rootTag
        self.identifier = identifier
    }
    
    public func parse() -> Elements? {
        let articleComments: Elements
        
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
