import Foundation
import Atributika

struct ArticleComment: Identifiable {

    var id: UUID = UUID()
    var level: CGFloat = 0
    var authorName: String?
    var authorTitle: String?
    var authorCompany: String?
    var authorCompanyUrl: String?
    var publicationDate: Date?
    var uiView: AttributedLabel?
    var uiViewHeigth: CGFloat?
}
