import Foundation

import Atributika

class TextAttributedLabel {
    
    public let htmlString: String
    
    private var attributedLabel: AttributedLabel
    
    init(htmlString: String) {
        self.htmlString = htmlString
        
        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0

        let all = Style.font(.systemFont(ofSize: 12))
        let link = Style("a").foregroundColor(.blue, .normal).foregroundColor(.brown, .highlighted)

        let attributedText = htmlString.style(tags: all, link).styleAll(all).styleLinks(link)

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

        attributedLabel.layer.borderWidth = 3
        attributedLabel.layer.borderColor = UIColor.red.cgColor
//        
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
        
        if htmlString.contains("li") {
            return attributedLabelSize.height - 10
        }

        return attributedLabelSize.height

    }
}

class ImageAttributedLabel {
    
    public let htmlString: String
    
    private var attributedLabel: AttributedLabel
    
    init(htmlString: String) {
        self.htmlString = htmlString
        
        let attributedLabel = AttributedLabel()
        attributedLabel.numberOfLines = 0
        
        let all = Style.font(.systemFont(ofSize: 12))

        let attributedText = htmlString.style(tags: [])
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
