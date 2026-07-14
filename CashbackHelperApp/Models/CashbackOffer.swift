import Foundation
import SwiftData


@Model
final class CashbackOffer {

    @Attribute(.unique)
    var id: UUID

    /// Первый день месяца
    var month: Date

    /// Отображаемое название категории
    var category: String

    /// Нормализованное значение для поиска
    var searchCategory: String

    var percent: Double

    var bank: Bank


    init(
        month: Date,
        category: String,
        percent: Double,
        bank: Bank
    ) {

        self.id = UUID()
        self.month = month
        self.category = category
        self.searchCategory =
            CashbackOffer.normalize(category)
        self.percent = percent
        self.bank = bank
    }



    static func normalize(
        _ value: String
    ) -> String {

        value
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
            .folding(
                options:
                    .diacriticInsensitive,
                locale:
                    .current
            )
            .lowercased()
    }
}
