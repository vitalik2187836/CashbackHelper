import Foundation
import SwiftData


enum CashbackSearchService {


    @MainActor
    static func findBest(
        category: String
    ) async throws -> BestCashbackResult {


        let container =
            try ModelContainerProvider
                .makeContainer()


        let context =
            ModelContext(
                container
            )



        let persons =
            try context.fetch(
                FetchDescriptor<Person>()
            )



        var bestOffer:
            CashbackOffer?



        var bestPerson:
            Person?



        var bestBank:
            Bank?



        for person in persons {


            for bank in person.banks {


                for offer in bank.offers {



                    guard
                        offer.category
                            .localizedCaseInsensitiveContains(
                                category
                            )
                    else {

                        continue

                    }



                    if
                        bestOffer == nil
                        ||
                        offer.percent >
                        bestOffer!.percent
                    {


                        bestOffer =
                            offer


                        bestPerson =
                            person


                        bestBank =
                            bank


                    }


                }


            }


        }



        guard

            let person =
                bestPerson,

            let bank =
                bestBank,

            let offer =
                bestOffer

        else {


            throw CashbackSearchError.notFound


        }



        return BestCashbackResult(

            person:
                person,

            bank:
                bank,

            offer:
                offer

        )


    }


}



enum CashbackSearchError:
    LocalizedError {


    case notFound



    var errorDescription:
        String? {


        switch self {


        case .notFound:

            return
                "Не найден кэшбэк для выбранной категории"


        }


    }


}
