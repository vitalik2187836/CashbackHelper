import Foundation
import SwiftData

@MainActor
final class ShareRepository {

    struct PersonItem: Identifiable, Hashable {

        let id: UUID
        let name: String

    }

    struct BankItem: Identifiable, Hashable {

        let id: UUID
        let ownerID: UUID
        let name: String

    }

    private let context: ModelContext

    init(
        context: ModelContext
    ) {

        self.context = context

    }

    func loadPersons() throws -> [PersonItem] {

        let descriptor =
            FetchDescriptor<Person>(
                sortBy: [
                    SortDescriptor(
                        \.name
                    )
                ]
            )

        return try context
            .fetch(
                descriptor
            )
            .map {

                PersonItem(

                    id: $0.id,

                    name: $0.name

                )

            }

    }

    func loadBanks(
        ownerID: UUID
    ) throws -> [BankItem] {

        let descriptor =
            FetchDescriptor<Person>(

                predicate:
                    #Predicate<Person> {

                        $0.id == ownerID

                    }

            )

        guard

            let person =
                try context
                    .fetch(
                        descriptor
                    )
                    .first

        else {

            return []

        }

        return person.banks

            .sorted {

                $0.name < $1.name

            }

            .map {

                BankItem(

                    id: $0.id,

                    ownerID: ownerID,

                    name: $0.name

                )

            }

    }

    func bank(
        id: UUID
    ) throws -> Bank? {

        let descriptor =
            FetchDescriptor<Bank>(

                predicate:
                    #Predicate<Bank> {

                        $0.id == id

                    }

            )

        return try context
            .fetch(
                descriptor
            )
            .first

    }

    func offer(
        month: Date,
        category: String,
        bankID: UUID
    ) throws -> CashbackOffer? {

        guard

            let bank =
                try bank(
                    id: bankID
                )

        else {

            return nil

        }

        return bank.offers.first {

            Calendar.current.isDate(

                $0.month,

                equalTo: month,

                toGranularity: .month

            )

            &&

            CashbackOffer.normalize(
                $0.category
            )

            ==

            CashbackOffer.normalize(
                category
            )

        }

    }
        func saveOffers(
        bankID: UUID,
        month: Date,
        offers: [ParsedCashbackOffer]
    ) throws {

        guard
            let bank = try bank(id: bankID)
        else {
            throw NSError(
                domain: "ShareRepository",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Банк не найден."
                ]
            )
        }

        for parsedOffer in offers {

            let category =
                parsedOffer.category
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

            guard !category.isEmpty else {
                continue
            }

            if let existingOffer =
                try offer(
                    month: month,
                    category: category,
                    bankID: bankID
                ) {

                existingOffer.percent =
                    parsedOffer.percent

                existingOffer.category =
                    category

                existingOffer.searchCategory =
                    CashbackOffer.normalize(
                        category
                    )

            } else {

                let cashbackOffer =
                    CashbackOffer(

                        month: month,

                        category: category,

                        percent: parsedOffer.percent,

                        bank: bank

                    )

                context.insert(
                    cashbackOffer
                )

                bank.offers.append(
                    cashbackOffer
                )

            }

        }

        try context.save()

    }

}