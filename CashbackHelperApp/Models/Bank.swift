import Foundation
import SwiftData


@Model
final class Bank {


    @Attribute(.unique)
    var id: UUID


    var name: String


    var owner: Person



    @Relationship(
        deleteRule:
            .cascade,
        inverse:
            \CashbackOffer.bank
    )
    var offers: [CashbackOffer] = []



    init(
        name: String,
        owner: Person
    ) {

        self.id = UUID()

        self.name = name

        self.owner = owner

    }

}
