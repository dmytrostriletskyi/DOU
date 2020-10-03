import Foundation

import Alamofire

class PublicationsService: ObservableObject {
    
    private let fetchPublicationsLimit: Int64 = 10
    private let fetchPublicationsOffsetStep: Int64 = 10
    
    private var currentFetchingPage: Int64 = 0
    private var currentlyFetchingPublications: Bool = false
    
    @Published var publications = [Publication]()

    init() {
        fetch(limit: fetchPublicationsLimit, offset: 0)
        currentFetchingPage += 1
    }

    private func fetch(limit: Int64, offset: Int64) -> Void {
        
        currentlyFetchingPublications = true
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        AF.request(
            "https://api.dou.ua/articles/?limit=\(limit)&offset=\(offset)", method: .get
        ).validate().responseDecodable(of: Publications.self, decoder: decoder) { (response) in
            guard let fetchedPublications = response.value else {
                self.currentlyFetchingPublications = false
                return
            }

            self.publications.append(contentsOf: fetchedPublications.results)
            self.currentlyFetchingPublications = false
        }
    }
    
    private func shouldFetchNext(currentPublication: Publication? = nil) -> Bool {
        if currentlyFetchingPublications {
            return false
        }

        guard let currentPublication = currentPublication else {
            return true
        }
        
        guard let lastPublication = publications.last else {
            return true
        }
        
        if currentPublication.id == lastPublication.id {
            return true
        }

        return false
    }

    func fetchNext(currentPublication: Publication? = nil) -> Void {
        if shouldFetchNext(currentPublication: currentPublication) {
            fetch(limit: fetchPublicationsLimit, offset: currentFetchingPage * fetchPublicationsOffsetStep)
            currentFetchingPage += 1
        }
    }
}
