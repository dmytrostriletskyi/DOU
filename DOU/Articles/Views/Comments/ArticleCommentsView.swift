import Foundation
import SwiftUI

struct ArticleCommentsView: View {
    
    public let articleAuthorName: String
    public var articleComments: [ArticleComment] = [ArticleComment]()
    private let articleCommentsStyle: ArticleCommentsStyle = ArticleCommentsStyle()
    
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
                        top: 0,
                        leading: 20 + (15 * articleComment.level),
                        bottom: 0,
                        trailing: 20
                    )
                )
            }
        }
    }
}
