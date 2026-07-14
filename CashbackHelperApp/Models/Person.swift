import Foundation
import SwiftData


@Model
final class Person {


    @Attribute(.unique)
    var id: UUID


    var name: String



    @Relationship(
        deleteRule:
            .cascade,
        inverse:
            \Bank.owner
    )
    var banks: [Bank] = []



    init(
        name: String
    ) {

        self.id = UUID()

        self.name = name

    }

}
