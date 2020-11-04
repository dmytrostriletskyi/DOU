import Foundation
import SwiftUI

struct ArticleView: View {
    
    public let article: Article

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
                            Text("").frame(height: 10)
                            GeometryReader { _ in
                                HStack(spacing: 15) {
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
                                }.padding(.bottom, 10)
                            }.padding(.leading, 21)
                            ForEach(htmlStrings, id: \.id) { htmlString in
                                if htmlString.type == HtmlStringType.text {
                                    PostTextView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }

                                if htmlString.type == HtmlStringType.image {
                                    PostImageView(uiView: htmlString.uiView).frame(height: htmlString.uiViewHeigth)
                                }
                            }.padding(.horizontal, 20)
                            Divider()
                            VStack {
                                if article.commentsCount > 0 {
                                    NavigationLink(
                                        destination: ArticleCommentsScreenView(article: article)
                                    ) {
                                        (
                                            Text(
                                                Image(
                                                    systemName: "bubble.right.fill"
                                                )
                                            ) + Text(
                                                " \(article.commentsCount) комментарі"
                                            )
                                        ).foregroundColor(
                                            Color.black
                                        )
                                    }
                                } else {
                                    (
                                        Text(
                                            Image(
                                                systemName: "bubble.right.fill"
                                            )
                                        ) + Text(
                                            " Немає комментарів"
                                        )
                                    ).foregroundColor(
                                        Color.black
                                    )
                                }
                            }.frame(height: 30)
                        }
                    }
                }.padding(.bottom, 15)
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
}
