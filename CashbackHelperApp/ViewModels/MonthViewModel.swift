import Foundation
import Observation


@Observable
final class MonthViewModel {


    var selectedMonth =
    MonthService.currentMonth()



    func title() -> String {

        let formatter =
        DateFormatter()

        formatter.locale =
        Locale(identifier: "ru_RU")

        formatter.dateFormat =
        "LLLL yyyy"


        return formatter
            .string(from: selectedMonth)
            .capitalized

    }



    func nextMonth() {

        selectedMonth =
        Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: selectedMonth
        )
        ?? selectedMonth

    }



    func previousMonth() {

        selectedMonth =
        Calendar.current.date(
            byAdding: .month,
            value: -1,
            to: selectedMonth
        )
        ?? selectedMonth

    }
}
