import Foundation
import SwiftUI

import Atributika

class ArticleEmbedYoutubeVideoAttributedUIView {
    let url: URL

    private var attributedLabel: AttributedLabel
    private let style = Style_()

    init(url: URL) {
        self.url = url

        let youtubeVideoIdentifier: String = url.absoluteString.components(separatedBy: "/").last!
        let html = "<p>Вiдео: <a href=\"https://www.youtube.com/watch?v=\(youtubeVideoIdentifier)\" target=\"_blank\">https://www.youtube.com/watch?v=\(youtubeVideoIdentifier)</a><p>"
        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                    ofSize: style.textSize
            )
        )

        let paragraph = Style(
            "p"
        ).baselineOffset(
            style.paragraphLineSPacing
        ).obliqueness(
            style.emphasizedTextObliqueness
        ).foregroundColor(.gray)

        let link = Style("a").foregroundColor(
            style.linkColor, .normal
        ).foregroundColor(
            .brown, .highlighted
        ).underlineStyle(
            style.linkUnderlineStyle
        )

        let tags = [
            all,
            paragraph,
            link
        ]

        let attributedText = html.style(tags: tags).styleAll(all)

        attributedLabel.attributedText = attributedText

        attributedLabel.onClick = { _, detection in
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
        let emphasizedTextObliqueness: Float = 0.24
        let textSize: CGFloat = 16
        let paragraphLineSPacing: Float = 2
        let linkColor: Atributika.Color = Atributika.Color(red: 0.09, green: 0.46, blue: 0.67, alpha: 1.00)
        let linkUnderlineStyle = NSUnderlineStyle.single
        let telegramRegerenceColor = #colorLiteral(red: 0.9032747149, green: 0.9623904824, blue: 0.9787710309, alpha: 1)
    }
}
