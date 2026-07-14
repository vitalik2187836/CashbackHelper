import Foundation
import SwiftData


@MainActor
final class CashbackRepository {


    private let context: ModelContext


    init(
        context: ModelContext
    ) {
        self.context = context
    }



    // MARK: - Person


    func addPerson(
        name: String
    ) -> Person {


        let person = Person(
            name: name
        )


        context.insert(
            person
        )


        save()


        return person
    }



    func deletePerson(
        _ person: Person
    ) {

        context.delete(
            person
        )

        save()
    }



    // MARK: - Bank


    func addBank(
        name: String,
        owner: Person
    ) -> Bank {


        let bank = Bank(
            name: name,
            owner: owner
        )


        context.insert(
            bank
        )


        save()


        return bank
    }



    func deleteBank(
        _ bank: Bank
    ) {

        context.delete(
            bank
        )

        save()
    }



    // MARK: - Cashback offers


    func addOffer(
        month: Date,
        category: String,
        percent: Double,
        bank: Bank
    ) -> CashbackOffer {


        let offer = CashbackOffer(
            month: month,
            category: category,
            percent: percent,
            bank: bank
        )


        context.insert(
            offer
        )


        save()


        return offer
    }



    func deleteOffer(
        _ offer: CashbackOffer
    ) {

        context.delete(
            offer
        )

        save()
    }



    // MARK: - Search


    func search(
        category: String,
        month: Date
    ) -> [CashbackOffer] {


        let normalized =
        CashbackOffer.normalize(
            category
        )


        let descriptor =
        FetchDescriptor<CashbackOffer>(
            predicate:
                #Predicate {
                    $0.searchCategory.contains(normalized)
                    &&
                    $0.month == month
                },
            sortBy:
                [
                    SortDescriptor(
                        \.percent,
                        order: .reverse
                    )
                ]
        )


        return
        (try? context.fetch(descriptor))
        ?? []
    }



    // MARK: - Helpers


    private func save() {

        do {

            try context.save()

        } catch {

            print(
                "SwiftData save error:",
                error
            )

        }
    }
}