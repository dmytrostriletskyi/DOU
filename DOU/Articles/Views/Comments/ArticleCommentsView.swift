import Foundation
import SwiftUI

struct ArticleCommentsView: View {
    
    public let articleAuthorName: String
    public var articleComments: [ArticleComment] = [ArticleComment]()

    private let style: Style = Style()
    
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
                    PostTextView(
                        uiView: articleComment.uiView!
                    ).frame(
                        height: articleComment.uiViewHeigth!
                    )
                    Divider()
                }.padding(
                    EdgeInsets(
                        top: style.commentPaddingTop,
                        leading: style.commentPaddingLeading + (style.nestedCommentPaddingLeading * articleComment.level),
                        bottom: style.commentPaddingBottom,
                        trailing: style.commentPaddinTrailing
                    )
                )
            }
        }
    }
    
    struct Style {
        public let commentPaddingTop: CGFloat = 0
        public let commentPaddingLeading: CGFloat = 20
        public let commentPaddingBottom: CGFloat = 0
        public let commentPaddinTrailing: CGFloat = 20
        public let nestedCommentPaddingLeading: CGFloat = 15
    }
}
