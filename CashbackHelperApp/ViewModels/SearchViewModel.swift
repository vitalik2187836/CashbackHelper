import Foundation
import Observation

@Observable
final class SearchViewModel {

    var searchText = ""


    func filteredRecords(
        from records: [CashbackRecord],
        month: Date
    ) -> [CashbackRecord] {


        guard !searchText.isEmpty else {
            return []
        }


        return records
            .filter {

                $0.category
                    .localizedCaseInsensitiveContains(
                        searchText
                    )

                &&
                MonthService.isSameMonth(
                    $0.month,
                    month
                )

            }
            .sorted {

                $0.percent > $1.percent

            }

    }
}
