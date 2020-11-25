import Foundation

struct Topic: Identifiable {
    var id: UUID = UUID()
    var authorName: String?
    var url: String?
    var title: String?
    var type: String?
    var subject: String?
    var views: Int64?
    var commentsCount: Int64?
    var publicationDate: Date?
}
