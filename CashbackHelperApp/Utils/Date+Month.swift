import Foundation


extension Date {

    var startOfMonth: Date {

        let calendar = Calendar.current

        return calendar.date(
            from: calendar.dateComponents(
                [
                    .year,
                    .month
                ],
                from: self
            )
        ) ?? self
    }


    var monthTitle: String {

        let formatter = DateFormatter()

        formatter.locale =
            Locale(identifier: "ru_RU")

        formatter.dateFormat =
            "LLLL yyyy"

        let value =
        formatter.string(
            from: self
        )

        return value.prefix(1).uppercased()
        + value.dropFirst()
    }


    static var nextMonth: Date {

        Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: Date()
        )!
        .startOfMonth
    }
}
