import Foundation
import SwiftUI

struct ArticleView: View {
    let article: Article

    private let style = Style()

    @State var isActivityIndicatorLoaing: Bool = true

    @State private var articleContents: [ArticleContent] = [ArticleContent]()

    var body: some View {
        Group {
            if isActivityIndicatorLoaing {
                ActivityIndicator(isLoading: $isActivityIndicatorLoaing)
            } else {
                ScrollView {
                    Group {
                        VStack {
                            Text("").frame(height: style.informationPaddingTop)
                            GeometryReader { _ in
                                HStack(spacing: style.informationSpacingHorizontal) {
                                    AttributedPostAuthorName(authorName: article.authorName)
                                    AttributedPostPublicationDate(
                                        publicationDate: DateRepresentation(
                                            date: article.publicationDate
                                        ).get(
                                            localization: .ukrainian
                                        )
                                    )
                                    AttributedPostViews(views: article.views)
                                    AttributedPostCommentsCount(commentsCount: article.commentsCount)
                                }.padding(.bottom, style.informationPaddingBottom)
                            }.padding(.leading, style.informationPaddingLeading)
                            ForEach(articleContents, id: \.id) { articleContent in
                                AttributedContentView(uiView: articleContent.uiView).frame(height: articleContent.uiViewHeigth)
                            }.padding(.horizontal, style.textPaddingLeading)
                            Divider()
                            VStack {
                                if article.commentsCount > 0 {
                                    NavigationLink(
                                        destination: ArticleCommentsScreenView(article: article)
                                    ) {
                                        (
                                            Text(
                                                Image(
                                                    systemName: style.commentsImageSystemName
                                                )
                                            ) + Text(
                                                " \(article.commentsCount) \(style.commentsNameUkrainian.lowercased())"
                                            )
                                        ).foregroundColor(
                                            style.commentsNameColor
                                        )
                                    }
                                } else {
                                    (
                                        Text(
                                            Image(
                                                systemName: style.commentsImageSystemName
                                            )
                                        ) + Text(
                                            " \(style.noCommentsNameUkrainian)"
                                        )
                                    ).foregroundColor(
                                        style.commentsNameColor
                                    )
                                }
                            }.frame(height: style.commentsHeight)
                        }
                    }
                }.padding(.bottom, style.textPaddingBottom)
            }
        }.onAppear {
            Html(url: article.url).get { html in
                guard let html = html else {
                    return
                }

                let articleHtmlSource = ArticleHtmlSource(
                    html: html,
                    rootTag: "article",
                    identifier: .class_
                )

                let articleService = ArticleService(source: articleHtmlSource)

                self.articleContents = articleService.get()
                self.isActivityIndicatorLoaing = false
            }
        }
    }

    struct Style {
        let informationSpacingHorizontal: CGFloat = 15
        let informationPaddingLeading: CGFloat = 20
        let informationPaddingTop: CGFloat = 10
        let informationPaddingBottom: CGFloat = 10
        let textPaddingBottom: CGFloat = 15
        let textPaddingLeading: CGFloat = 20
        let commentsHeight: CGFloat = 30
        let commentsImageSystemName: String = "bubble.right.fill"
        let commentsNameColor = Color.black
        let commentsNameUkrainian: String = "Коментарі"
        let commentsNameRussian: String = "Комментарии"
        let noCommentsNameUkrainian: String = "Немає комментарів"
        let noCommentsNameRussian: String = "Нет комментариев"
    }
}
