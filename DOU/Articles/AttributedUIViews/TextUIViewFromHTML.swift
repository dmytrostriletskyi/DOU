import Foundation
import SwiftUI

import Atributika

struct AttributedPostItemStyle {
    let textSize: CGFloat = 16
    let emphasizedTextSize: CGFloat = 12
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
    let informationFont: String = "Arial"
    let informationSize: Int64 = 13
    let informationColor: SwiftUI.Color = SwiftUI.Color(
        red: 0,
        green: 0,
        blue: 0,
        opacity: 1.0
    )
    let viewsImageSystemName: String = "eye.fill"
}

class ArticleContentAttributedUIView {
    let html: String

    private var attributedLabel: AttributedLabel
    private let attributedPostStyle = AttributedPostItemStyle()

    init(html: String) {
        self.html = html

        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                ofSize: attributedPostStyle.textSize
            )
        )

        let paragraph = Style("p").baselineOffset(attributedPostStyle.paragraphLineSPacing)

        let link = Style("a").foregroundColor(
            attributedPostStyle.linkColor, .normal
        ).foregroundColor(
            .brown, .highlighted
        ).underlineStyle(
            attributedPostStyle.linkUnderlineStyle
        )

        let strike = Style("strike").strikethroughStyle(.single)

        let indicating = Style("i").obliqueness(
            attributedPostStyle.emphasizedTextObliqueness
        )

        let headerOneSize = Style("h1").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerOneSize,
                weight: attributedPostStyle.headerWeight
            )
        )

        let headerTwoSize = Style("h2").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerTwoSize,
                weight: attributedPostStyle.headerWeight
            )
        )

        let headerThreeSize = Style("h3").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerThreeSize,
                weight: attributedPostStyle.headerWeight
            )
        )

        let headerFourSize = Style("h4").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerFourSize,
                weight: attributedPostStyle.headerWeight
            )
        )

        let headerFiveSize = Style("h5").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerFiveSize,
                weight: attributedPostStyle.headerWeight
            )
        )

        let headerSixSize = Style("h5").font(
            UIFont.systemFont(
                ofSize: attributedPostStyle.headerSixSize,
                weight: attributedPostStyle.headerWeight
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
}
