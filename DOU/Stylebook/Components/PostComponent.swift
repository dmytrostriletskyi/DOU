import Foundation
import SwiftUI
    
struct PostTitle: View {
    
    public let title: String
    
    private let postStyle: PostStyle = PostStyle()
    
    var body: some View {
        Text(
            title
        ).font(
            .custom(
                postStyle.titleFont,
                size: CGFloat(postStyle.titleSize)
            )
        ).fontWeight(
            .semibold
        ).foregroundColor(
            postStyle.titleColor
        ).multilineTextAlignment(
            .leading
        )
    }
}

struct PostAuthorName: View {
    
    public let authorName: String
    
    private let postStyle: PostStyle = PostStyle()

    var body: some View {
        Text(
            authorName
        ).font(
            .custom(
                postStyle.informationFont,
                size: CGFloat(postStyle.informationSize)
            )
        ).foregroundColor(
            postStyle.informationColor
        )
    }
}

struct PostPublicationDate: View {
    
    public let publicationDate: String
    
    private let postStyle: PostStyle = PostStyle()

    var body: some View {
        Text(
            publicationDate
        ).font(
            .custom(
                postStyle.informationFont,
                size: CGFloat(postStyle.informationSize)
            )
        ).foregroundColor(
            postStyle.informationColor
        )
    }
}

struct PostViews: View {
    
    public let views: Int64

    private let postStyle: PostStyle = PostStyle()
    
    var body: some View {
        HStack {
            (
                Text(
                    Image(
                        systemName: postStyle.viewsImageSystemName
                    )
                ) + Text(
                    " \(views)")
            ).font(
                .custom(
                    postStyle.informationFont,
                    size: CGFloat(postStyle.informationSize)
                )
            ).foregroundColor(
                postStyle.informationColor
            )
        }
    }
}
