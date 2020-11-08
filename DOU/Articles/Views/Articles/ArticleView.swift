import Foundation
import SwiftUI

struct ArticleView: View {
    public let article: Article
    
    private let style = Style()
    
    @State public var isActivityIndicatorLoaing: Bool = true

    @State private var htmlStrings: [HtmlString] = [HtmlString]()

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
                            ForEach(htmlStrings, id: \.id) { htmlString in
                                if htmlString.type == HtmlStringType.text {
                                    PostTextView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }

                                if htmlString.type == HtmlStringType.image {
                                    PostImageView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }
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
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let articleHtmlSource: ArticleHtmlSource = ArticleHtmlSource(
                    html: html,
                    rootTag: "article",
                    identifier: .class_
                )
                
                let articleService: ArticleService = ArticleService(source: articleHtmlSource)

                self.htmlStrings = articleService.get()
                self.isActivityIndicatorLoaing = false
            }
        }
    }
    
    struct Style {
        public let informationSpacingHorizontal: CGFloat = 15
        public let informationPaddingLeading: CGFloat = 20
        public let informationPaddingTop: CGFloat = 10
        public let informationPaddingBottom: CGFloat = 10
        public let textPaddingBottom: CGFloat = 15
        public let textPaddingLeading: CGFloat = 20
        public let commentsHeight: CGFloat = 30
        public let commentsImageSystemName: String = "bubble.right.fill"
        public let commentsNameColor: Color = Color.black
        public let commentsNameUkrainian: String = "Коментарі"
        public let commentsNameRussian: String = "Комментарии"
        public let noCommentsNameUkrainian: String = "Немає комментарів"
        public let noCommentsNameRussian: String = "Нет комментариев"
    }
}
