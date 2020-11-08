import Foundation
import SwiftUI

struct ArticleCommentsScreenView: View {
    let article: Article

    @State var isActivityIndicatorLoaing: Bool = true
    @State private var articleComments: [ArticleComment] = [ArticleComment]()
    @State private var articleBestComments: [ArticleComment] = [ArticleComment]()
    @State private var articleCommentsNumber: Int = 0

    private let style = Style()

    init(article: Article) {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: style.navigationBarHeaderSize,
                weight: UIFont.Weight.semibold
            )
        ]

        self.article = article
    }

    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    if !articleBestComments.isEmpty {
                        Text(
                            style.bestCommentsNameUkrainian
                        ).font(
                            Font.system(
                                size: style.articleBestCommentsTitleFontSize,
                                weight: style.articleBestCommentsTitleFontWeight,
                                design: style.articleBestCommentsTitleFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            .leading, style.commentsPaddingLeading
                        )
                        Divider()
                        ArticleCommentsView(
                            articleAuthorName: article.authorName,
                            articleComments: articleBestComments
                        )
                    }

                    if !articleComments.isEmpty {
                        Text(
                            "\(articleCommentsNumber) \(style.commentsNameUkrainian.lowercased())"
                        ).font(
                            Font.system(
                                size: style.articleCommentsNumberFontSize,
                                weight: style.articleCommentsNumberFontWeight,
                                design: style.articleCommentsNumberFontDesign
                            )
                        ).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        ).padding(
                            EdgeInsets(
                                top: articleBestComments.isEmpty ? 0 : 24,
                                leading: style.commentsPaddingLeading,
                                bottom: style.commentsPaddingBottom,
                                trailing: style.commentsPaddingTrailing
                            )
                        )
                        Divider()
                        ArticleCommentsView(
                            articleAuthorName: article.authorName,
                            articleComments: articleComments
                        )
                    }
                }.navigationBarTitle(
                    style.navigationBarHeaderNameUkrainian,
                    displayMode: .inline
                ).padding(
                    .top, style.commentsPaddingTop
                )
            }
        }.onAppear {
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let articleCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "commentsList",
                    identifier: .id
                )

                let articleBestCommentsHtmlSource = ArticleCommentsHtmlSource(
                    html: html,
                    rootTag: "b-comments __best",
                    identifier: .class_
                )

                let articleComments = ArticleCommentsService(source: articleCommentsHtmlSource)
                let articleBestComments = ArticleCommentsService(source: articleBestCommentsHtmlSource)

                self.articleComments = articleComments.get()
                self.articleBestComments = articleBestComments.get()
                self.articleCommentsNumber = self.articleComments.count
                self.isActivityIndicatorLoaing = false
            }
        }
    }

    struct Style {
        let articleBestCommentsTitleFontSize: CGFloat = 16
        let articleBestCommentsTitleFontWeight: Font.Weight = .semibold
        let articleBestCommentsTitleFontDesign: Font.Design = .default
        let articleCommentsNumberFontSize: CGFloat = 18
        let articleCommentsNumberFontWeight: Font.Weight = .semibold
        let articleCommentsNumberFontDesign: Font.Design = .default
        let commentsPaddingTop: CGFloat = 12
        let commentsPaddingLeading: CGFloat = 20
        let commentsPaddingBottom: CGFloat = 0
        let commentsPaddingTrailing: CGFloat = 0
        let commentsNameUkrainian: String = "Коментарі"
        let commentsNameRussian: String = "Комментарии"
        let bestCommentsNameUkrainian: String = "Найкращі коментарі"
        let bestCommentsNameRussian: String = "Лучшие комментарии"
        let navigationBarHeaderSize: CGFloat = 20
        let navigationBarHeaderNameUkrainian: String = "Коментарі"
        let navigationBarHeaderNameRussian: String = "Комментарии"
    }
}
