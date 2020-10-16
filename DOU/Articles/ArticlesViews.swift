import Foundation
import SwiftUI

struct ArticlesView: View {
    
    @ObservedObject var articlesService: ArticlesService = ArticlesService()
    
    private let navigationBarStyle: NavigationBarStyle = NavigationBarStyle()
    private let tabBarStyle: TabBarStyle = TabBarStyle()

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(
                name: navigationBarStyle.headerFont,
                size: CGFloat(navigationBarStyle.headerSize)
            )!,
        ]
    }

    var body: some View {
        VStack(alignment: .leading) {
            NavigationView() {
                List(
                    articlesService.article
                ) { (article: Article) in
                    NavigationLink(
                        destination: ArticleView(
                            article: article
                        )
                    ) {
                        ArticlesItemView(
                            article: article
                        ).onAppear {
                            articlesService.fetchNext(
                                currentArticle: article
                            )
                        }
                     }
                }.navigationBarTitle(
                    tabBarStyle.forumTabNameUkrainian,
                    displayMode: .inline
                )
            }
        }
    }
}

struct ArticlesItemView: View {
    
    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            RegularPostTitle(title: article.title)
            HStack(spacing: 15) {
                RegularPostAuthorName(authorName: article.authorName)
                RegularPostPublicationDate(
                    publicationDate: DateRepresentation(
                        date: article.publicationDate
                    ).get(
                        localization: .ukrainian
                    )
                )
                RegularPostViews(views: article.views)
            }
            .padding(
                .vertical, 1
            )
        }.padding(
            .vertical, 10
        )
    }
}

struct ArticleView: View {
    
    let article: Article

    @State var isActivityIndicatorLoaing: Bool = true
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
                        }
                    }
                }.padding(.bottom, 15)
            }
        }
        .onAppear {
            Html(url: article.url).get() { html in
                guard let html = html else {
                    return
                }

                let htmlParser: ArticlesHtmlParser = ArticlesHtmlParser(html: html, rootTag: "article")

                guard let htmlString: [HtmlString] = htmlParser.parse() else {
                    return
                }

                self.htmlStrings = htmlString
                self.isActivityIndicatorLoaing = false
            }
        }
    }
}
