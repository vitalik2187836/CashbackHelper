import Foundation

struct CashbackMonth: Hashable, Codable {

    let year: Int
    let month: Int

    init(date: Date) {

        let calendar = Calendar.current

        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
    }

    var title: String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")

        var components = DateComponents()
        components.year = year
        components.month = month

        let date = Calendar.current.date(from: components)!

        formatter.dateFormat = "LLLL yyyy"

        return formatter.string(from: date)
    }

    var firstDay: Date {

        var components = DateComponents()

        components.year = year
        components.month = month
        components.day = 1

        return Calendar.current.date(from: components)!
    }
}