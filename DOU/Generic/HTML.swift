import Foundation

import Alamofire

class Html {
    var url: String
    private var html: String?

    init(url: String) {
        self.url = url
        self.html = nil
    }

    private func fetch(
        completion: @escaping (String?) -> Void
    ) {
        AF.request(url, method: .get).validate().responseString { response in
            print("Fething an article HTML for \(self.url).")

            switch response.result {
            case .success(let html):
                completion(html)
                return
            case .failure(let error):
                print("Error during fetching an article HTML: \(error).")
                completion(nil)
                return
            }
        }
    }

    func get(
        completion: @escaping (String?) -> Void
    ) {
        fetch(completion: completion)
    }
}
