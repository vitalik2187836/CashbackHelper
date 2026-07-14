import Foundation

final class MonthService {

    static func currentMonth() -> Date {

        let calendar = Calendar.current

        return calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: Date()
            )
        ) ?? Date()
    }


    static func previousMonth() -> Date {

        Calendar.current.date(
            byAdding: .month,
            value: -1,
            to: currentMonth()
        ) ?? Date()

    }


    static func isSameMonth(
        _ first: Date,
        _ second: Date
    ) -> Bool {

        Calendar.current.isDate(
            first,
            equalTo: second,
            toGranularity: .month
        )
    }
}