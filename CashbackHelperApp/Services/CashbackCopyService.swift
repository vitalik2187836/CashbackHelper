import Foundation
import SwiftData

final class CashbackCopyService {


    static func copyPreviousMonth(
        for bank: Bank,
        records: [CashbackRecord],
        context: ModelContext
    ) {


        let oldRecords =
        records.filter {

            $0.bank.id == bank.id &&
            MonthService.isSameMonth(
                $0.month,
                MonthService.previousMonth()
            )

        }


        let currentRecords =
        records.filter {

            $0.bank.id == bank.id &&
            MonthService.isSameMonth(
                $0.month,
                MonthService.currentMonth()
            )

        }


        for old in oldRecords {


            let exists =
            currentRecords.contains {

                $0.category.lowercased()
                ==
                old.category.lowercased()

            }


            if !exists {

                let copy =
                CashbackRecord(
                    month: MonthService.currentMonth(),
                    category: old.category,
                    percent: old.percent,
                    bank: bank
                )


                context.insert(copy)

            }

        }


        try? context.save()

    }
}