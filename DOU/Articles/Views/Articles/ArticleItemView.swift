import Foundation
import SwiftUI

import URLImage

struct ArticlesItemView: View {
    
    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            URLImage(
                URL(
                    string: article.imageUrl
                )!,
                processors: [
                    Resize(
                        size: CGSize(width: UIScreen.main.bounds.size.width - 41.5, height: 179),
                        scale: UIScreen.main.scale)
                ],
                placeholder: {
                    ProgressView($0) { progress in
                        ZStack { }
                    }
                },
                content:  {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                }
            ).frame(
                width: UIScreen.main.bounds.size.width - 41.5,
                height: 179
            )
            Spacer()
            RegularPostTitle(title: article.title)
            HStack() {
                RegularPostAuthorName(authorName: article.authorName)
                RegularPostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: article.publicationDate
                    ).get(
                        localization: .ukrainian
                    )
                )
                Spacer()
                RegularPostViews(views: article.views)
                RegularPostCommentsCount(commentsCount: article.commentsCount)
            }.padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }
}
