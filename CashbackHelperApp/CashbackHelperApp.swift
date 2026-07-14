import SwiftUI
import SwiftData


@main
struct CashbackHelperApp: App {


    private let container: ModelContainer



    init() {


        do {


            container =
                try ModelContainerProvider
                    .makeContainer()


        } catch {


            fatalError(
                "Не удалось создать SwiftData контейнер: \(error)"
            )


        }


    }



    var body: some Scene {


        WindowGroup {


            RootView()


        }
        .modelContainer(
            container
        )


    }


}
