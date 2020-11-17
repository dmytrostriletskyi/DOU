import Foundation
import SwiftUI

struct NavigationBarStyle {
    
    public let headerFont: String = "Arial"
    public let headerSize: Int64 = 20
}

struct TabBarStyle {

    public let articlesTabImageSystemName: String = "doc.plaintext"
    public let topicsTabImageSystemName: String = "text.bubble"
    public let salariesTabImageSystemName: String = "dollarsign.circle"
    
    public let articlesTabNameUkrainian: String = "Стрічка"
    public let articlesTabHeaderNameRussian: String = "Лента"
    
    public let topicsTabNameUkrainian: String = "Форум"
    public let topicsTabHeaderNameRussian: String = "Форум"
    
    public let salariesTabNameUkrainian: String = "Зарплата"
    public let salariesabHeaderNameRussian: String = "Зарплата"
}

struct RegularPostItemStyle {
    
    public let titleFont: String = "Arial"
    public let titleSize: Int64 = 18
    public let titleColor: Color = Color(
        red: 0.09,
        green: 0.46,
        blue: 0.67,
        opacity: 1.0
    )
    
    public let informationFont: String = "Arial"
    public let informationSize: Int64 = 13
    public let informationColor: Color = Color(
        red: 0.47,
        green: 0.47,
        blue: 0.47,
        opacity: 1.0
    )
    
    public let viewsImageSystemName: String = "eye.fill"
}
