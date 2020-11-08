import Foundation
import SwiftUI

struct AttributedPostAuthorName: View {
    let authorName: String

    private let attributedPostItemStyle = AttributedPostItemStyle()

    var body: some View {
        Text(
            authorName
        ).font(
            .custom(
                attributedPostItemStyle.informationFont,
                size: CGFloat(attributedPostItemStyle.informationSize)
            )
        ).foregroundColor(
            attributedPostItemStyle.informationColor
        )
    }
}

struct AttributedPostPublicationDate: View {
    let publicationDate: String

    private let attributedPostItemStyle = AttributedPostItemStyle()

    var body: some View {
        Text(
            publicationDate
        ).font(
            .custom(
                attributedPostItemStyle.informationFont,
                size: CGFloat(attributedPostItemStyle.informationSize)
            )
        ).foregroundColor(
            attributedPostItemStyle.informationColor
        )
    }
}

struct AttributedPostViews: View {
    let views: Int64

    private let attributedPostItemStyle = AttributedPostItemStyle()

    var body: some View {
        HStack {
            (
                Text(
                    Image(
                        systemName: attributedPostItemStyle.viewsImageSystemName
                    )
                ) + Text(
                    " \(views)")
            ).font(
                .custom(
                    attributedPostItemStyle.informationFont,
                    size: CGFloat(attributedPostItemStyle.informationSize)
                )
            ).foregroundColor(
                attributedPostItemStyle.informationColor
            )
        }
    }
}

struct AttributedPostCommentsCount: View {
    let commentsCount: Int64

    private let attributedPostItemStyle = AttributedPostItemStyle()

    var body: some View {
        HStack {
            (
                Text(
                    Image(
                        systemName: "bubble.right.fill"
                    )
                ) + Text(
                    " \(commentsCount)")
            ).font(
                .custom(
                    attributedPostItemStyle.informationFont,
                    size: CGFloat(attributedPostItemStyle.informationSize)
                )
            ).foregroundColor(
                attributedPostItemStyle.informationColor
            )
        }
    }
}
