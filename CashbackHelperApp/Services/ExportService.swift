import Foundation


final class ExportService {


    static func export(
        persons: [Person]
    ) throws -> URL {


        let data =
        ExportData(

            persons:
                persons.map { person in


                    ExportPerson(
                        name:
                            person.name,

                        banks:
                            person.banks.map { bank in


                                ExportBank(
                                    name:
                                        bank.name,

                                    offers:
                                        bank.offers.map {

                                            ExportOffer(
                                                month:
                                                    $0.month,

                                                category:
                                                    $0.category,

                                                percent:
                                                    $0.percent
                                            )

                                        }
                                )

                            }
                    )

                }

        )


        let json =
            try JSONEncoder()
                .encode(data)


        let url =
            FileManager.default
                .temporaryDirectory
                .appending(
                    path:
                        "cashback_backup.json"
                )


        try json.write(
            to:
                url
        )


        return url

    }
}
