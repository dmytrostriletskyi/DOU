import Foundation
import SwiftUI

import Atributika

class TextAttributedLabel {

    public let htmlString: String
    
    private var attributedLabel: AttributedLabel
    private let attributedPostStyle: AttributedPostItemStyle = AttributedPostItemStyle()
    
    init(htmlString: String) {
        self.htmlString = htmlString
        
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
            headerOneSize,
            headerTwoSize,
            headerThreeSize,
            headerFourSize,
            headerFiveSize,
            headerSixSize,
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
    
    public func get() -> AttributedLabel {
        return self.attributedLabel
    }
    
    public func getHeight() -> CGFloat {
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)

        let attributedLabelSize = self.attributedLabel.sizeThatFits(
            CGSize(width: screenWidth - 40, height: CGFloat.greatestFiniteMagnitude)
        )

        return attributedLabelSize.height

    }
}

class ImageAttributedLabel {
    
    public let htmlString: String
    
    private let attributedPostStyle: AttributedPostItemStyle = AttributedPostItemStyle()
    private var attributedLabel: AttributedLabel
    
    init(htmlString: String) {
        self.htmlString = htmlString
        
        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0
        
        let all = Style.font(
            .systemFont(
                ofSize: attributedPostStyle.textSize
            )
        )

        let emphasizedText = Style("em").font(
            .systemFont(ofSize: attributedPostStyle.emphasizedTextSize)
        ).obliqueness(
            attributedPostStyle.emphasizedTextObliqueness
        )
        
        let attributedText = htmlString.style(tags: [emphasizedText])
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText.attributedString)

        var locationShift = 0

        for detection in attributedText.detections {
            switch detection.type {
            case .tag(let tag):
                if let imageLink = tag.attributes["src"] {
                    let url = URL(string: imageLink)!
                    let data = try? Data(contentsOf: url)
                    let image = UIImage(data: data!)!

                    let ratio = UIScreen.main.bounds.size.width / image.size.width
                    let hhhh = image.size.height * ratio
                    
                    let textAttachment = NSTextAttachment()

                    textAttachment.image = image
                    textAttachment.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.9, height: hhhh)

                    let imageAttrStr = NSAttributedString(attachment: textAttachment)
                    let nsrange = NSRange(detection.range, in: mutableAttributedString.string)
                    mutableAttributedString.insert(imageAttrStr, at: nsrange.location + locationShift)

                    locationShift += 1
                }

            default:
                break
            }
        }

        attributedLabel.attributedText = mutableAttributedString.styleAll(all)

        self.attributedLabel = attributedLabel
    }
    
    public func get() -> AttributedLabel {
        return self.attributedLabel
    }
    
    public func getHeight() -> CGFloat {
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
        
        let attributedLabelSize = self.attributedLabel.sizeThatFits(
            CGSize(width: screenWidth, height: CGFloat.greatestFiniteMagnitude)
        )
        
        return attributedLabelSize.height
    }
}

struct CheckMarkButtonIcon: View {
    var body: some View {
        Image(
            systemName: "checkmark"
        ).foregroundColor(
            Color.blue
        ).font(
            Font.system(
                size: 15,
                weight: .semibold
            )
        )
    }
}
