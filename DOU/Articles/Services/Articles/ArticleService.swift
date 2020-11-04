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

class ArticleService {
    
    public let source: ArticleHtmlSource
    
    private let htmlTagsToEscape: [String] = ["#text"]
    private let textHtmlTags: [String] = ["p", "h1", "h2", "h3", "h4", "h5", "h6"]
    private let unsupportedClasses: [String] = ["class=\"b-post-tags\""]
    private let russianLetters: [Character] = Array("аАбБвВгГдДеЕёЁжЖзЗиИйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ")
    
    init(source: ArticleHtmlSource) {
        self.source = source
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

    public func get() -> [HtmlString] {
        var htmlStrings: [HtmlString] = [HtmlString]()
        
        guard let article: Element = source.parse() else {
            return htmlStrings
        }

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
