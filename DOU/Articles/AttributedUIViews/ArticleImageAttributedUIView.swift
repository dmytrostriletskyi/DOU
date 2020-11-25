import Foundation
import SwiftUI

import Atributika

class ArticleImageAttributedUIView {
    let html: String

    private let style = Style_()
    private var attributedLabel: AttributedLabel

    init(html: String) {
        self.html = html

        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(
            .systemFont(
                ofSize: style.textSize
            )
        )

        let emphasizedText = Style("em").font(
            .systemFont(ofSize: style.emphasizedTextSize)
        ).obliqueness(
            style.emphasizedTextObliqueness
        )

        let attributedText = html.style(tags: [emphasizedText])
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText.attributedString)

        for detection in attributedText.detections {
            switch detection.type {
            case .tag(let tag):
                if let imageLink = tag.attributes["src"] {
                    let url = URL(string: imageLink)!

                    var urlData = Data()

                    do {
                        urlData = try Data(contentsOf: url)
                    } catch {
                        attributedLabel.attributedText = mutableAttributedString.styleAll(all)
                        self.attributedLabel = attributedLabel
                        print("The following HTML string is out of regularity: \(html).")
                        return
                    }

                    let image: UIImage? = UIImage(data: urlData)

                    if image == nil {
                        attributedLabel.attributedText = mutableAttributedString.styleAll(all)
                        self.attributedLabel = attributedLabel
                        print("The following HTML string is out of regularity: \(html).")
                        return
                    }

                    let screenWidthToImageWidthRatio = UIScreen.main.bounds.size.width / image!.size.width
                    let imageHeight = image!.size.height * screenWidthToImageWidthRatio - 15

                    let textAttachment = NSTextAttachment()

                    textAttachment.image = image
                    textAttachment.bounds = CGRect(
                        x: 0,
                        y: 0,
                        width: UIScreen.main.bounds.size.width * 0.9,
                        height: imageHeight
                    )

                    let imageAttrubtedString = NSAttributedString(attachment: textAttachment)
                    let mutableAttributedStringRange = NSRange(detection.range, in: mutableAttributedString.string)

                    mutableAttributedString.insert(imageAttrubtedString, at: mutableAttributedStringRange.location)
                }
            default:
                break
            }
        }

        attributedLabel.attributedText = mutableAttributedString.styleAll(all)
        self.attributedLabel = attributedLabel
    }

    func get() -> AttributedLabel {
        return self.attributedLabel
    }

    func getHeight() -> CGFloat {
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)

        let attributedLabelSize = self.attributedLabel.sizeThatFits(
            CGSize(width: screenWidth, height: CGFloat.greatestFiniteMagnitude)
        )

        return attributedLabelSize.height
    }

    struct Style_ {
        let textSize: CGFloat = 16
        let emphasizedTextSize: CGFloat = 12
        let emphasizedTextObliqueness: Float = 0.24
    }
}
