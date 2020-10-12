import Foundation
import SwiftUI

struct NavigationBarStyle {
    public let headerFont: String = "Arial"
    public let headerSize: Int64 = 25
}

struct TabBarStyle {
    
    public let homeTabImageSystemName: String = "house"
    public let lentaTabImageSystemName: String = "doc.plaintext"
    public let forumTabImageSystemName: String = "text.bubble"
    public let jobsTabImageSystemName: String = "briefcase"
    public let settingsTabImageSystemName: String = "gear"
    
    public let homeTabNameUkrainian: String = "Головна"
    public let homeTabHeaderNameRussian: String = "Главная"
    
    public let lentaTabNameUkrainian: String = "Лента"
    public let lentaTabHeaderNameRussian: String = "Лента"
    
    public let forumTabNameUkrainian: String = "Форум"
    public let forumTabHeaderNameRussian: String = "Форум"
    
    public let jobsTabNameUkrainian: String = "Робота"
    public let jobsTabHeaderNameRussian: String = "Работа"
    
    public let settingsTabNameUkrainian: String = "Налаштування"
    public let settingsTabHeaderNameRussian: String = "настройки"
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
