//
//  DateUtils.swift
//  DOU
//
//  Created by Dima on 01/10/2020.
//

import Foundation


//enum LocalizationDateRepresentation {
//    case today
//    case yesterday
//
//    public func get() -> String {
//        switch self {
//        case .today:
//            return "uk_UA"
//        case .yesterday:
//            return "ru_RU"
//        }
//    }
//}

class DateRepresentation {
    
    var date: Date
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    init(date: Date) {
        self.date = date
    }
    
    public func get(localization: Localization) -> String {
        if calendar.isDateInToday(date) {
            switch localization {
            case .ukrainian:
                return "сьогодні"
            case .russian:
                return "сегодня"
            }
        }
        
        if calendar.isDateInYesterday(date) {
            switch localization {
            case .ukrainian:
                return "вчора"
            case .russian:
                return "вчера"
            }
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd MMMM"
        
        switch localization {
        case .ukrainian:
            dateFormatter.locale = Locale(identifier: "uk_UA")
        case .russian:
            dateFormatter.locale = Locale(identifier: "ru_RU")
        }
        
        let dateAsString = dateFormatter.string(from: date)
        return dateAsString
    }
}
