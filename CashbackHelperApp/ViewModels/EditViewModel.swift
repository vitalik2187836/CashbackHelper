import Foundation
import Observation
import SwiftData

@Observable
final class EditViewModel {


    func delete(
        _ record: CashbackRecord,
        context: ModelContext
    ) {

        context.delete(record)

        try? context.save()

    }

}
