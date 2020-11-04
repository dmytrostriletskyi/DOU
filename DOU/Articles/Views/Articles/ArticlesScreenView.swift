import Foundation
import SwiftUI

struct ArticlesScreenView: View {

    @State private var articles = [Article]()
    @State private var currentlyFetchingArticles: Bool = true
    
    private let articlesService: ArticlesService = ArticlesService(
        source: ArticlesApiSource()
    )

    private let navigationBarStyle: NavigationBarStyle = NavigationBarStyle()
    private let tabBarStyle: TabBarStyle = TabBarStyle()

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: CGFloat(navigationBarStyle.headerSize),
                weight: UIFont.Weight.semibold
            )
        ]
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
                    tabBarStyle.articlesTabNameUkrainian,
                    displayMode: .inline
                )
            }
        }.onAppear {
            self.articlesService.get { result in
                self.articles = result
            }
            
            self.currentlyFetchingArticles = false
        }
    }
}
