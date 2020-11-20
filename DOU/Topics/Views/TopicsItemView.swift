import Foundation
import SwiftUI

struct TopicsItemView: View {
    
    let topic: Topic
    private let style = Style()
    
    var body: some View {
        VStack(alignment: .leading) {
            PostTitle(
                title: topic.title!,
                font: style.titleFont,
                color: style.titleColor,
                size: style.titleSize
            )
            HStack() {
                PostAuthorName(
                    authorName: topic.authorName!,
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
                PostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: topic.publicationDate!
                    ).get(
                        localization: .ukrainian
                    ),
                    font: style.informationFont,
                    color: style.informationColor,
                    size: style.informationSize
                )
                Spacer()
                PostCommentsCount(
                    commentsCount: topic.commentsCount!,
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
        let commentsCountImageSystemName = "bubble.right.fill"
    }
}
