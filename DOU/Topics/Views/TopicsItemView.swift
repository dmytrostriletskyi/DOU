import Foundation
import SwiftUI

struct TopicsItemView: View {
    
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading) {
            RegularPostTitle(title: topic.title!)
            HStack() {
                RegularPostAuthorName(authorName: topic.authorName!)
                RegularPostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: topic.publicationDate!
                    ).get(
                        localization: .ukrainian
                    )
                )
                Spacer()
                RegularPostCommentsCount(commentsCount: topic.commentsCount!)
            }.padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }
}
