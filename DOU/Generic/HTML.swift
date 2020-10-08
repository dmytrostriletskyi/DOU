import Foundation

import SwiftSoup
import Alamofire
import Atributika

enum HtmlStringType {
    case text
    case image
}

struct HtmlString: Identifiable {

    var id: UUID = UUID()
    var content: String
    var type: HtmlStringType
    var uiView: AttributedLabel
    var uiViewHeigth: CGFloat
}

class Html {

    public var url: String
    private var html: String?

    init(url: String) {
        self.url = url
        self.html = nil
    }

    private func fetch(
        completion: @escaping (String?) -> Void
    ) {
        AF.request(url, method: .get).validate().responseString { response in
            print("Fething an article HTML for \(self.url).")

            switch response.result {
            case .success(let html):
                completion(html)
                return
            case .failure(let error):
                print("Error during fetching an article HTML: \(error).")
                completion(nil)
                return
            }
        }
    }

    public func get(
        completion: @escaping (String?) -> Void
    ) {
        fetch(completion: completion)
    }
}

class HtmlParser {
    
    public let html: String
    public let rootTag: String
    
    private let htmlTagsToEscape: [String] = ["#text", "div"]
    
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
    
    public func parse() -> [HtmlString]? {
        guard let article: Element = getArticle() else {
            return nil
        }
        
        var htmlStrings: [HtmlString] = [HtmlString]()
        
        for childNode in article.getChildNodes() {
            let htmlStringTagName: String = childNode.nodeName()
            var htmlString: String = childNode.description
            
            if htmlTagsToEscape.contains(htmlStringTagName) {
                continue
            }

            if htmlString.contains("img") {
                htmlString = htmlString.replacingOccurrences(of: "</p>", with: "</img></p>")

                let imageAttributedLabel: ImageAttributedLabel = ImageAttributedLabel(htmlString: htmlString)

                htmlStrings.append(HtmlString(
                    content: htmlString,
                    type: HtmlStringType.image,
                    uiView: imageAttributedLabel.get(),
                    uiViewHeigth: imageAttributedLabel.getHeight()
                ))
            } else {
                let textAttributedLabel: TextAttributedLabel = TextAttributedLabel(htmlString: htmlString)

                htmlStrings.append(HtmlString(
                    content: htmlString,
                    type: HtmlStringType.text,
                    uiView: textAttributedLabel.get(),
                    uiViewHeigth: textAttributedLabel.getHeight()
                ))
            }
        }
        
        return htmlStrings
    }
}
