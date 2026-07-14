import Foundation
import SwiftData


@Model
final class CategoryDictionaryItem {

    @Attribute(.unique)
    var id: UUID

    var name: String

    var isFavorite: Bool


    init(
        name: String,
        isFavorite: Bool = false
    ) {

        self.id = UUID()
        self.name = name
        self.isFavorite = isFavorite

    }

}