import Foundation
import SwiftUI

struct ArticleCommentsView: View {
    let articleAuthorName: String
    var articleComments: [ArticleComment] = [ArticleComment]()

    private let style = Style()

    var body: some View {
        ForEach(articleComments, id: \.id) { articleComment in
            if articleComment.uiView != nil {
                VStack(alignment: .leading) {
                    ArticleCommentHeaderView(
                        articleAuthorName: articleAuthorName,
                        authorName: articleComment.authorName!,
                        authorTitle: articleComment.authorTitle,
                        authorCompany: articleComment.authorCompany,
                        publicationDate: articleComment.publicationDate!
                    )
                    AttributedContentView(
                        uiView: articleComment.uiView!
                    ).frame(
                        height: articleComment.uiViewHeigth!
                    )
                    Divider()
                }.padding(
                    EdgeInsets(
                        top: style.commentPaddingTop,
                        leading: style.commentPaddingLeading + (
                            style.nestedCommentPaddingLeading * articleComment.level
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
