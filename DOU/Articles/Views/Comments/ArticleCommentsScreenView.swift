import Foundation
import SwiftUI

struct ArticleCommentsScreenView: View {

    public let article: Article

    @State public var isActivityIndicatorLoaing: Bool = true
    @State private var articleComments: [ArticleComment] = [ArticleComment]()
    @State private var articleBestComments: [ArticleComment] = [ArticleComment]()
    @State private var articleCommentsNumber: Int = 0

    private let style: Style = Style()
    
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
    
    struct Style {
        public let articleBestCommentsTitleFontSize: CGFloat = 16
        public let articleBestCommentsTitleFontWeight: Font.Weight = .semibold
        public let articleBestCommentsTitleFontDesign: Font.Design = .default
        public let articleCommentsNumberFontSize: CGFloat = 18
        public let articleCommentsNumberFontWeight: Font.Weight = .semibold
        public let articleCommentsNumberFontDesign: Font.Design = .default
        public let commentsPaddingTop: CGFloat = 12
        public let commentsPaddingLeading: CGFloat = 20
        public let commentsPaddingBottom: CGFloat = 0
        public let commentsPaddingTrailing: CGFloat = 0
        public let commentsNameUkrainian: String = "Коментарі"
        public let commentsNameRussian: String = "Комментарии"
        public let bestCommentsNameUkrainian: String = "Найкращі коментарі"
        public let bestCommentsNameRussian: String = "Лучшие комментарии"
        public let navigationBarHeaderSize: CGFloat = 20
        public let navigationBarHeaderNameUkrainian: String = "Коментарі"
        public let navigationBarHeaderNameRussian: String = "Комментарии"
    }
}
