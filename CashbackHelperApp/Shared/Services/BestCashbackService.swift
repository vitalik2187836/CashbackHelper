import Foundation
import SwiftData


@MainActor
final class BestCashbackService {

    private let context: ModelContext

    init(
        context: ModelContext
    ) {
        self.context = context
    }


    func bestOffer(
        category: String
    ) throws -> BestCashbackResult? {

        let normalized =
            CashbackOffer.normalize(category)


        let descriptor =
            FetchDescriptor<CashbackOffer>(
                predicate: #Predicate {

                    $0.searchCategory == normalized

                }
            )


        let offers =
            try context.fetch(descriptor)


        guard
            let best =
                offers.max(
                    by: {

                        if $0.percent != $1.percent {
                            return $0.percent < $1.percent
                        }

                        return $0.month < $1.month
                    }
                )
        else {
            return nil
        }


        return BestCashbackResult(
            person: best.bank.owner,
            bank: best.bank,
            offer: best
        )

    }

}
