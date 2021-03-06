import Foundation

import Atributika

struct Article: Identifiable, Decodable {
    var id: Int64
    var url: String
    var title: String
    var category: String
    var tags: String
    var views: Int64
    var commentsCount: Int64
    var authorName: String
    var publicationDate: Date
    var imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case title = "title"
        case category = "category"
        case tags = "tags"
        case views = "pageviews"
        case commentsCount = "comments_count"
        case authorName = "author_name"
        case publicationDate = "published"
        case imageUrl = "img_big"
    }
}
