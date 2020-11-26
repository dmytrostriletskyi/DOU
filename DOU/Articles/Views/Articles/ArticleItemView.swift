import Foundation
import SwiftUI

import URLImage

struct ArticlesItemView: View {
    let article: Article
    let currentDevice: String = UIDevice.current.name

    private let style = Style()

    var body: some View {
        VStack(alignment: .leading) {
            if !DeviceType.allIPadDevicesList.contains(currentDevice) {
                URLImage(
                    URL(
                        string: article.imageUrl
                    )!,
                    processors: [],
                    placeholder: {
                        ProgressView($0) { _ in
                            ZStack { }
                        }
                    },
                    content: {
                        $0.image
                        .resizable()
                    }
                ).frame(
                    width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * 0.11,
                    height: 186
                )
                Spacer()
            }
            PostTitle(
                title: article.title,
                font: style.titleFont,
                color: style.titleColor,
                size: style.titleSize
            )
            HStack() {
                PostAuthorName(
                    authorName: article.authorName,
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
                PostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: article.publicationDate
                    ).get(
                        localization: .ukrainian
                    ),
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
                Spacer()
                PostViewsCount(
                    viewsCount: article.views,
                    imageSystemNane: style.viewsCountImageSystemName,
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
                PostCommentsCount(
                    commentsCount: article.commentsCount,
                    imageSystemNane: style.commentsCountImageSystemName,
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
            }.padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }

    struct Style {
        let informationFont: String = "Arial"
        let informationSize: CGFloat = 13
        let informationColor = Color.gray
        let titleFont: String = "Arial"
        let titleSize: CGFloat = 18
        let titleColor = Color(
            red: 0.09,
            green: 0.46,
            blue: 0.67,
            opacity: 1.0
        )
        let viewsCountImageSystemName = "eye.fill"
        let commentsCountImageSystemName = "bubble.right.fill"
    }
}
