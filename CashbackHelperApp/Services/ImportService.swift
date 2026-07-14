import Foundation
import SwiftData


final class ImportService {


    static func importFile(
        url: URL,
        context: ModelContext
    ) throws -> ImportResult {


        let data =
            try Data(
                contentsOf:
                    url
            )


        let backup =
            try JSONDecoder()
                .decode(
                    ExportData.self,
                    from:
                        data
                )



        let existingPersons =
            try context.fetch(
                FetchDescriptor<Person>()
            )


        for person in existingPersons {

            context.delete(
                person
            )

        }


        context.processPendingChanges()



        var personsCount = 0
        var banksCount = 0
        var offersCount = 0



        for personData in backup.persons {


            let person =
                Person(
                    name:
                        personData.name
                )


            context.insert(
                person
            )


            personsCount += 1



            for bankData in personData.banks {


                let bank =
                    Bank(
                        name:
                            bankData.name,

                        owner:
                            person
                    )


                context.insert(
                    bank
                )


                banksCount += 1



                for offerData in bankData.offers {


                    let offer =
                        CashbackOffer(

                            month:
                                offerData.month,

                            category:
                                offerData.category,

                            percent:
                                offerData.percent,

                            bank:
                                bank

                        )


                    context.insert(
                        offer
                    )


                    offersCount += 1

                }

            }

        }



        context.processPendingChanges()


        try context.save()



        return ImportResult(

            persons:
                personsCount,

            banks:
                banksCount,

            offers:
                offersCount

        )

    }

}
