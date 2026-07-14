import SwiftData

enum ShareExtensionContainer {

    static let container: ModelContainer = {

        do {

            return try ModelContainerProvider.makeContainer()

        } catch {

            fatalError(
                "Не удалось создать ModelContainer: \(error)"
            )

        }

    }()

}
