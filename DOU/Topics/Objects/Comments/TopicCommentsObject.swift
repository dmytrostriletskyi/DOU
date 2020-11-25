import Foundation

import Atributika

struct TopicComment: Identifiable {
    var id = UUID()
    var level: CGFloat = 0
    var authorName: String?
    var authorTitle: String?
    var authorCompany: String?
    var authorCompanyUrl: String?
    var publicationDate: Date?
    var uiView: AttributedLabel?
    var uiViewHeigth: CGFloat?
}
