import Foundation
import SwiftUI

import Atributika

class ArticleContentAttributedUIView {
    let html: String

    private var attributedLabel: AttributedLabel
    private let style = Style_()

    init(html: String) {
        self.html = html

        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                ofSize: style.textSize
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

        let strike = Style("strike").strikethroughStyle(.single)

        let indicating = Style("i").obliqueness(
            style.emphasizedTextObliqueness
        )

        let headerOneSize = Style("h1").font(
            UIFont.systemFont(
                ofSize: style.headerOneSize,
                weight: style.headerWeight
            )
        )

        let headerTwoSize = Style("h2").font(
            UIFont.systemFont(
                ofSize: style.headerTwoSize,
                weight: style.headerWeight
            )
        )

        let headerThreeSize = Style("h3").font(
            UIFont.systemFont(
                ofSize: style.headerThreeSize,
                weight: style.headerWeight
            )
        )

        let headerFourSize = Style("h4").font(
            UIFont.systemFont(
                ofSize: style.headerFourSize,
                weight: style.headerWeight
            )
        )

        let headerFiveSize = Style("h5").font(
            UIFont.systemFont(
                ofSize: style.headerFiveSize,
                weight: style.headerWeight
            )
        )

        let headerSixSize = Style("h5").font(
            UIFont.systemFont(
                ofSize: style.headerSixSize,
                weight: style.headerWeight
            )
        )

        let tags = [
            all,
            paragraph,
            link,
            strike,
            indicating,
            headerOneSize,
            headerTwoSize,
            headerThreeSize,
            headerFourSize,
            headerFiveSize,
            headerSixSize
        ]

        var transformers: [TagTransformer] = [TagTransformer]()

        if html.contains("<ul>") {
            transformers = [
                TagTransformer.brTransformer,
                TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
                TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
            ]
        }

        if html.contains("<ol>") {
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

        let attributedText = html.style(tags: tags, transformers: transformers).styleAll(all).styleLinks(link)

        attributedLabel.attributedText = attributedText

        attributedLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                if let href = tag.attributes["href"] {
                    if let url = URL(string: href) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            default:
                break
            }
        }

        self.attributedLabel = attributedLabel
    }

    func get() -> AttributedLabel {
        return self.attributedLabel
    }

    func getHeight() -> CGFloat {
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)

        let attributedLabelSize = self.attributedLabel.sizeThatFits(
            CGSize(width: screenWidth - 40, height: CGFloat.greatestFiniteMagnitude)
        )

        return attributedLabelSize.height
    }

    struct Style_ {
        let textSize: CGFloat = 16
        let emphasizedTextObliqueness: Float = 0.24
        let headerOneSize: CGFloat = 22
        let headerTwoSize: CGFloat = 20
        let headerThreeSize: CGFloat = 18
        let headerFourSize: CGFloat = 16
        let headerFiveSize: CGFloat = 14
        let headerSixSize: CGFloat = 12
        let headerWeight: UIFont.Weight = UIFont.Weight.bold
        let paragraphLineSPacing: Float = 2
        let linkColor: Atributika.Color = Atributika.Color(red: 0.09, green: 0.46, blue: 0.67, alpha: 1.00)
        let linkUnderlineStyle = NSUnderlineStyle.single
    }
}
