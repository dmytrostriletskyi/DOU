import Foundation

import Alamofire

class ArticlesService: ObservableObject {
    
    private let fetchArticlesLimit: Int64 = 10
    private let fetchArticlesOffsetStep: Int64 = 10
    
    private var currentFetchingPage: Int64 = 0
    private var currentlyFetchingArticles: Bool = false
    
    @Published var article = [Article]()

    init() {
        fetch(limit: fetchArticlesLimit, offset: 0)
        currentFetchingPage += 1
    }

    private func fetch(limit: Int64, offset: Int64) -> Void {
        
        currentlyFetchingArticles = true
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        AF.request(
            "https://api.dou.ua/articles/?limit=\(limit)&offset=\(offset)", method: .get
        ).validate().responseDecodable(of: Articles.self, decoder: decoder) { (response) in
            guard let fetchedPublications = response.value else {
                self.currentlyFetchingArticles = false
                return
            }

            self.article.append(contentsOf: fetchedPublications.results)
            self.currentlyFetchingArticles = false
        }
    }
    
    private func shouldFetchNext(currentArticle: Article? = nil) -> Bool {
        if currentlyFetchingArticles {
            return false
        }

        guard let currentArticle = currentArticle else {
            return true
        }
        
        guard let lastArticle = article.last else {
            return true
        }
        
        if currentArticle.id == lastArticle.id {
            return true
        }

        return false
    }

    func fetchNext(currentArticle: Article? = nil) -> Void {
        if shouldFetchNext(currentArticle: currentArticle) {
            fetch(limit: fetchArticlesLimit, offset: currentFetchingPage * fetchArticlesOffsetStep)
            currentFetchingPage += 1
        }
    }
}
