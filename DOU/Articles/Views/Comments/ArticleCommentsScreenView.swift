import Foundation
import SwiftUI

struct ArticleCommentsScreenView: View {

    public let article: Article

    @State public var isActivityIndicatorLoaing: Bool = true
    @State private var articleComments: [ArticleComment] = [ArticleComment]()
    @State private var articleBestComments: [ArticleComment] = [ArticleComment]()
    @State private var articleCommentsNumber: Int = 0

    private let articleCommentsStyle: ArticleCommentsStyle = ArticleCommentsStyle()
    
    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    if !articleBestComments.isEmpty {
                        Text(
                            "Найкращі коментарі"
                        ).font(
                            Font.system(
                                size: articleCommentsStyle.articleBestCommentsTitleFontSize,
                                weight: articleCommentsStyle.articleBestCommentsTitleFontWeight,
                                design: articleCommentsStyle.articleBestCommentsTitleFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            .leading, 20
                        )
                        Divider()
                        ArticleCommentsView(
                            articleAuthorName: article.authorName,
                            articleComments: articleBestComments
                        )
                    }

                    if !articleComments.isEmpty {
                        Text(
                            "\(articleCommentsNumber) коментарі"
                        ).font(
                            Font.system(
                                size: articleCommentsStyle.articleCommentsNumberFontSize,
                                weight: articleCommentsStyle.articleCommentsNumberFontWeight,
                                design: articleCommentsStyle.articleCommentsNumberFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            EdgeInsets(
                                top: articleBestComments.isEmpty ? 0 : 24,
                                leading: 20,
                                bottom: 0,
                                trailing: 0
                            )
                        )
                        Divider()
                        ArticleCommentsView(
                            articleAuthorName: article.authorName,
                            articleComments: articleComments
                        )
                    }
                }.navigationBarTitle(
                    "Комментарі"
                ).padding(
                    .top, 12
                )
            }
        }.onAppear {
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let articleCommentsHtmlSource: ArticleCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "commentsList",
                    identifier: .id
                )

                let articleBestCommentsHtmlSource: ArticleCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "b-comments __best",
                    identifier: .class_
                )

                let articleComments: ArticleCommentsService = ArticleCommentsService(source: articleCommentsHtmlSource)
                let articleBestComments: ArticleCommentsService = ArticleCommentsService(source: articleBestCommentsHtmlSource)

                self.articleComments = articleComments.get()
                self.articleBestComments = articleBestComments.get()
                self.articleCommentsNumber = self.articleComments.count
                self.isActivityIndicatorLoaing = false
            }
        }
    }
}
