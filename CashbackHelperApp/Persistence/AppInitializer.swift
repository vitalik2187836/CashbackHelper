import Foundation
import SwiftData

final class AppInitializer {


    static func setup(
        context: ModelContext
    ) {


        let descriptor =
        FetchDescriptor<Person>()


        let persons =
        try? context.fetch(
            descriptor
        )


        guard persons?.isEmpty == true
        else {
            return
        }


        // Первый запуск.
        // База остается пустой.
        // Пользователь самостоятельно
        // добавляет владельцев и банки.

    }

}