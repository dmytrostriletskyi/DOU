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
        
        return htmlString
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
