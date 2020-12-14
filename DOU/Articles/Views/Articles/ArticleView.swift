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
                            Text("").frame(
                                height: style.informationPaddingTop
                            )
                            GeometryReader { _ in
                                ArticleInformationView(
                                    article: article
                                ).padding(
                                    .bottom, style.informationPaddingBottom
                                )
                            }.padding(
                                .leading, style.informationPaddingLeading
                            )
                            ForEach(articleContents, id: \.id) { articleContent in
                                AttributedContentView(
                                    uiView: articleContent.uiView
                                ).frame(
                                    height: articleContent.uiViewHeigth
                                )
                            }.padding(
                                .horizontal, style.contentPaddingLeading
                            )
                            Divider()
                            ArticleCommentsInformationView(
                                article: article
                            )
                        }
                    }.navigationBarTitle(
                        style.navigationBarHeaderNameUkrainian,
                        displayMode: .inline
                    )
                }.padding(
                    .bottom, style.contentPaddingBottom
                )
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
        let contentPaddingBottom: CGFloat = 15
        let contentPaddingLeading: CGFloat = 20
        let navigationBarHeaderNameUkrainian: String = "Стаття"
        let navigationBarHeaderNameRussian: String = "Статья"
    }
}

struct ArticleInformationView: View {
    let article: Article

    private let style = Style()

    var body: some View {
        HStack(spacing: style.spacingHorizontal) {
            PostAuthorName(
                authorName: article.authorName,
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostPublicationDate(
                publicationDate: DateRepresentation(
                    date: article.publicationDate
                ).get(
                    localization: .ukrainian
                ),
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostViewsCount(
                viewsCount: article.views,
                imageSystemNane: style.viewsCountImageSystemName,
                font: style.font,
                color: style.color,
                size: style.size
            )
            PostCommentsCount(
                commentsCount: article.commentsCount,
                imageSystemNane: style.commentsCountImageSystemName,
                font: style.font,
                color: style.color,
                size: style.size
            )
        }
    }

    struct Style {
        let font: String = "Arial"
        let size: CGFloat = 13
        let color = Color(
            red: 0,
            green: 0,
            blue: 0,
            opacity: 1.0
        )
        let spacingHorizontal: CGFloat = 15
        let viewsCountImageSystemName: String = "eye.fill"
        let commentsCountImageSystemName: String = "bubble.right.fill"
    }
}

struct ArticleCommentsInformationView: View {
    let article: Article

    private let style = Style()

    var body: some View {
        VStack {
            if article.commentsCount > 0 {
                NavigationLink(
                    destination: ArticleCommentsScreenView(article: article)
                ) {
                    (
                        Text(
                            Image(
                                systemName: style.imageSystemName
                            )
                        ) + Text(
                            " \(article.commentsCount) \(style.wordCommentsUkrainian.lowercased())"
                        )
                    ).foregroundColor(
                        style.color
                    )
                }
            } else {
                (
                    Text(
                        Image(
                            systemName: style.imageSystemName
                        )
                    ) + Text(
                        " \(style.wordNoCommentsNameUkrainian)"
                    )
                ).foregroundColor(
                    style.color
                )
            }
        }.frame(height: style.height)
    }

    struct Style {
        let height: CGFloat = 30
        let imageSystemName: String = "bubble.right.fill"
        let color = Color.black
        let wordCommentsUkrainian: String = "Коментарі"
        let wordCommentsRussian: String = "Комментарии"
        let wordNoCommentsNameUkrainian: String = "Немає комментарів"
        let wordNoCommentsNameRussian: String = "Нет комментариев"
    }
}
