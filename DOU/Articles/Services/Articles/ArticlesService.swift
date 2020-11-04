import Foundation

class ArticlesService {
    
    public let source: ArticlesApiSource
    
    init(source: ArticlesApiSource) {
        self.source = source
    }

    func get(completion: @escaping ([Article]) -> Void) {
        source.fetch(completion: completion)
    }
    
    func getNext(completion: @escaping ([Article]) -> Void) {
        source.fetchNext(completion: completion)
    }
}
