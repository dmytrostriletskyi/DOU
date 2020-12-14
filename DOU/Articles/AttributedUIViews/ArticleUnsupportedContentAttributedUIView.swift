import Foundation
import SwiftUI

import Atributika

class ArticleUnsupportedContentAttributedUIView {
    private var attributedLabel: AttributedLabel
    private let style = Style_()

    init() {
        let html: String = "<p>⚠️ Ця частина тексту (наприклад, графік чи код) наразі не пидтрімується. Ми працюємо над цим. Дякуємо за розуміння.</p>"
        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                ofSize: style.textSize
            )
        )

        let paragraph = Style("p").baselineOffset(style.paragraphLineSPacing).foregroundColor(.gray)

        let tags = [
            all,
            paragraph
        ]

        let attributedText = html.style(tags: tags).styleAll(all)

        attributedLabel.attributedText = attributedText

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
        let paragraphLineSPacing: Float = 2
    }
}
