import Foundation
import SwiftData

@Model
final class AppMonth {

    @Attribute(.unique)
    var id: UUID

    var date: Date


    init(date: Date) {

        self.id = UUID()
        self.date = date

    }
}