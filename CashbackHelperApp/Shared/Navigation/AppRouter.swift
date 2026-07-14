import Foundation
import Observation


@Observable
final class AppRouter {


    enum Destination: Equatable {

        case bank(
            personID: UUID,
            bankID: UUID
        )

    }



    var destination: Destination?



    func handle(
        url: URL
    ) {

        guard
            url.scheme == "cashbackhelper"
        else {

            return

        }


        let components =
            url.pathComponents


        guard
            components.count >= 5
        else {

            return

        }


        guard
            components[1] == "person",
            components[3] == "bank"
        else {

            return

        }


        guard

            let personID =
                UUID(
                    uuidString:
                        components[2]
                ),

            let bankID =
                UUID(
                    uuidString:
                        components[4]
                )

        else {

            return

        }


        destination =
            .bank(
                personID:
                    personID,
                bankID:
                    bankID
            )

    }



    func clear() {

        destination = nil

    }

}
