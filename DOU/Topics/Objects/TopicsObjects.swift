import Foundation

struct Topic: Identifiable {

    var id: UUID = UUID()
    var authorName: String?
    var link: String?
    var title: String?
    var type: String?
    var subject: String?
    var commentsCount: Int64?
    var publicationDate: Date?
}
