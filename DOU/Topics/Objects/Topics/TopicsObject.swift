import Foundation

struct Topic: Identifiable {
    var id = UUID()
    var authorName: String?
    var url: String?
    var title: String?
    var type: String?
    var subject: String?
    var viewsCount: Int64?
    var commentsCount: Int64?
    var publicationDate: Date?
    var imageUrl: String?
}
