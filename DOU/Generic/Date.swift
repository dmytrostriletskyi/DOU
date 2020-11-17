import Foundation

class DateRepresentation {
    var date: Date

    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()

    init(date: Date) {
        self.date = date
    }

    func get(localization: Localization) -> String {
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
