import Foundation

import Alamofire

class ArticlesApiSource {
    private let fetchArticlesLimit: Int64 = 20
    private let fetchArticlesOffsetStep: Int64 = 20

    private var currentFetchingPage: Int64 = 0
    private var currentlyFetchingArticles: Bool = false

    func fetch(limit: Int64 = 20, offset: Int64 = 0, completion: @escaping ([Article]) -> Void) {
        var articles = [Article]()

        currentlyFetchingArticles = true

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        AF.request(
            "https://api.dou.ua/articles/?limit=\(limit)&offset=\(offset)", method: .get
        ).validate().responseDecodable(of: Articles.self, decoder: decoder) { response in
            guard let fetchedPublications = response.value else {
                self.currentlyFetchingArticles = false
                return
            }

            // If caqtegory is empty string, then it's an article, otherwise a topic
            articles.append(contentsOf: fetchedPublications.results.filter { !$0.category.isEmpty })
            self.currentFetchingPage += 1

            completion(articles)
        }
    }

    func fetchNext(completion: @escaping ([Article]) -> Void) {
        fetch(limit: fetchArticlesLimit, offset: currentFetchingPage * fetchArticlesOffsetStep, completion: completion)
        currentFetchingPage += 1
    }
}
