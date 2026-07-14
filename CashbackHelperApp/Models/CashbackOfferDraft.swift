import Foundation
import Observation


@Observable
final class CashbackOfferDraft: Identifiable {

    let id = UUID()

    var category: String = ""

    var percent: String = ""

    var isValidated: Bool = false



    var categoryInvalid: Bool {

        guard isValidated else {
            return false
        }


        return category
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty

    }



    var percentInvalid: Bool {

        guard isValidated else {
            return false
        }


        let value =
            Double(
                percent
                    .replacingOccurrences(
                        of: ",",
                        with: "."
                    )
            )


        guard let value else {
            return true
        }


        return value <= 0 ||
               value > 100

    }



    var isValid: Bool {

        let category =
            category
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )


        guard !category.isEmpty else {
            return false
        }


        guard let value =
                Double(
                    percent
                        .replacingOccurrences(
                            of: ",",
                            with: "."
                        )
                )
        else {
            return false
        }


        return value > 0 &&
               value <= 100

    }

}
