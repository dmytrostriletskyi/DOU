import Foundation
import SwiftUI

struct RegularPostTitle: View {
    let title: String

    private let regularPostItemStyle = RegularPostItemStyle()

    var body: some View {
        Text(
            title
        ).font(
            .custom(
                regularPostItemStyle.titleFont,
                size: CGFloat(regularPostItemStyle.titleSize)
            )
        ).fontWeight(
            .semibold
        ).foregroundColor(
            regularPostItemStyle.titleColor
        ).multilineTextAlignment(
            .leading
        )
    }
}

struct RegularPostAuthorName: View {
    let authorName: String

    private let regularPostItemStyle = RegularPostItemStyle()

    var body: some View {
        Text(
            authorName
        ).font(
            .custom(
                regularPostItemStyle.informationFont,
                size: CGFloat(regularPostItemStyle.informationSize)
            )
        ).foregroundColor(
            regularPostItemStyle.informationColor
        )
    }
}

struct RegularPostPublicationDate: View {
    let publicationDate: String

    private let regularPostItemStyle = RegularPostItemStyle()

    var body: some View {
        Text(
            publicationDate
        ).font(
            .custom(
                regularPostItemStyle.informationFont,
                size: CGFloat(regularPostItemStyle.informationSize)
            )
        ).foregroundColor(
            regularPostItemStyle.informationColor
        )
    }
}

struct RegularPostViews: View {
    let views: Int64

    private let regularPostItemStyle = RegularPostItemStyle()

    var body: some View {
        HStack {
            (
                Text(
                    Image(
                        systemName: regularPostItemStyle.viewsImageSystemName
                    )
                ) + Text(
                    " \(views)")
            ).font(
                .custom(
                    regularPostItemStyle.informationFont,
                    size: CGFloat(regularPostItemStyle.informationSize)
                )
            ).foregroundColor(
                regularPostItemStyle.informationColor
            )
        }
    }
}

struct RegularPostCommentsCount: View {
    let commentsCount: Int64

    private let regularPostItemStyle = RegularPostItemStyle()

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
                    regularPostItemStyle.informationFont,
                    size: CGFloat(regularPostItemStyle.informationSize)
                )
            ).foregroundColor(
                regularPostItemStyle.informationColor
            )
        }
    }
}
