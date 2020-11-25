import Foundation
import SwiftUI

import Atributika

class ArticleCommentAttributedUIView {
    let htmlString: String

    private var attributedLabel: AttributedLabel
    private let style = Style_()

    init(htmlString: String) {
        self.htmlString = htmlString

        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                ofSize: 14
            )
        )

        let paragraph = Style("p").baselineOffset(style.paragraphLineSPacing)

        let link = Style("a").foregroundColor(
            style.linkColor, .normal
        ).foregroundColor(
            .brown, .highlighted
        ).underlineStyle(
            style.linkUnderlineStyle
        )

        let blockquote = Style("blockquote").obliqueness(
            style.emphasizedTextObliqueness
        ).foregroundColor(Color.gray)

        let tags = [
            all,
            paragraph,
            link,
            blockquote
        ]

        var transformers: [TagTransformer] = [TagTransformer]()

        if htmlString.contains("<ul>") {
            transformers = [
                TagTransformer.brTransformer,
                TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
                TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
            ]
        }

        if htmlString.contains("<ol>") {
            var pointsCounter = 0

            transformers = [
                TagTransformer.brTransformer,
                TagTransformer(tagName: "ol", tagType: .start) { _ in
                    pointsCounter = 0
                    return ""
                },
                TagTransformer(tagName: "li", tagType: .start) { _ in
                    pointsCounter += 1
                    return "\(pointsCounter > 1 ? "\n" : "")\(pointsCounter). "
                }
            ]
        }

        let attributedText = htmlString.style(tags: tags, transformers: transformers).styleAll(all).styleLinks(link)

        attributedLabel.attributedText = attributedText

        attributedLabel.onClick = { _, detection in
            switch detection.type {
            case .tag(let tag):
                if let href = tag.attributes["href"] {
                    if let url = URL(string: href) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            case .link(var url):
                if url.absoluteString.contains("www.") {
                    let urlString = url.absoluteString.replacingOccurrences(of: "www.", with: "https://")
                    url = URL(string: urlString)!
                }

                if (
                    !url.absoluteString.contains("www.") &&
                    !url.absoluteString.contains("http://") &&
                    !url.absoluteString.contains("https://")
                ) {
                    let urlString = "https://\(url.absoluteString)"
                    url = URL(string: urlString)!
                }

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            default:
                break
            }
        }

        self.attributedLabel = attributedLabel
    }

    func get() -> AttributedLabel {
        return self.attributedLabel
    }

    func getHeight(level: CGFloat) -> CGFloat {
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)

        let attributedLabelSize = self.attributedLabel.sizeThatFits(
            CGSize(width: screenWidth - 40 - (15 * level), height: CGFloat.greatestFiniteMagnitude)
        )

        return attributedLabelSize.height
    }

    struct Style_ {
        let emphasizedTextObliqueness: Float = 0.24
        let paragraphLineSPacing: Float = 2
        let linkColor: Atributika.Color = Atributika.Color(red: 0.09, green: 0.46, blue: 0.67, alpha: 1.00)
        let linkUnderlineStyle = NSUnderlineStyle.single
    }
}
