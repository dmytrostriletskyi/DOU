import Foundation
import SwiftUI

struct TopicCommentsView: View {
    let topicAuthorName: String
    var topicComments: [TopicComment] = [TopicComment]()

    private let style = Style()

    var body: some View {
        ForEach(topicComments, id: \.id) { topicComment in
            if topicComment.uiView != nil {
                VStack(alignment: .leading) {
                    TopicCommentsHeaderView(
                        topicAuthorName: topicAuthorName,
                        authorName: topicComment.authorName!,
                        authorTitle: topicComment.authorTitle,
                        authorCompany: topicComment.authorCompany,
                        publicationDate: topicComment.publicationDate!
                    )
                    AttributedContentView(
                        uiView: topicComment.uiView!
                    ).frame(
                        height: topicComment.uiViewHeigth!
                    )
                    Divider()
                }.padding(
                    EdgeInsets(
                        top: style.commentPaddingTop,
                        leading: style.commentPaddingLeading + (
                            style.nestedCommentPaddingLeading * topicComment.level
                        ),
                        bottom: style.commentPaddingBottom,
                        trailing: style.commentPaddinTrailing
                    )
                )
            }
        }
    }

    struct Style {
        let commentPaddingTop: CGFloat = 0
        let commentPaddingLeading: CGFloat = 20
        let commentPaddingBottom: CGFloat = 0
        let commentPaddinTrailing: CGFloat = 20
        let nestedCommentPaddingLeading: CGFloat = 15
    }
}
