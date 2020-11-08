import Foundation
import SwiftUI

import URLImage

struct ArticlesScreenView: View {

    public let articlesService: ArticlesService
    public let initialArticles: [Article]
    
    @State private var articles: [Article] = [Article]()
    @State private var currentlyFetchingArticles: Bool = true

    private let style: Style = Style()

    init(articlesService: ArticlesService, initialArticles: [Article]) {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: style.navigationBarHeaderSize,
                weight: UIFont.Weight.semibold
            )
        ]

        self.articlesService = articlesService
        self.initialArticles = initialArticles
    }

    var body: some View {
        VStack(alignment: .leading) {
            NavigationView() {
                List(articles) { (article: Article) in
                    ZStack {
                        ArticlesItemView(
                            article: article
                        ).onAppear {
                            if self.currentlyFetchingArticles {
                                return
                            }
                            
                            guard let lastArticle = articles.last else {
                                return
                            }
                            
                            if article.id != lastArticle.id {
                                return
                            }
                            
                            self.articlesService.getNext { result in
                                self.articles.append(contentsOf: result)
                            }
                        }.padding(
                            .horizontal, 5
                        )
                        NavigationLink(
                            destination: ArticleView(article: article),
                            label: {}
                        ).frame(
                            width: 0
                        )
                    }
                }.navigationBarTitle(
                    style.navigationBarHeaderNameUkrainian,
                    displayMode: .inline
                )
            }
        }.onAppear {
            self.articles.append(contentsOf: initialArticles)
            self.currentlyFetchingArticles = false
        }
    }
    
    struct Style {
        public let navigationBarHeaderSize: CGFloat = 20
        public let navigationBarHeaderNameUkrainian: String = "Стрічка"
        public let navigationBarHeaderNameRussian: String = "Лента"
    }
}
