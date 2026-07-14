import SwiftUI


struct RootView: View {


    @State
    private var router =
        AppRouter()



    var body: some View {


        TabView {


            SearchView()

                .tabItem {

                    Label(
                        "Поиск",
                        systemImage:
                            "magnifyingglass"
                    )

                }



            DataView()

                .tabItem {

                    Label(
                        "Данные",
                        systemImage:
                            "folder"
                    )

                }



            SettingsView()

                .tabItem {

                    Label(
                        "Настройки",
                        systemImage:
                            "gear"
                    )

                }


        }

        .environment(
            router
        )

        .onOpenURL { url in


            router.handle(
                url:
                    url
            )


        }


        .task {


            if let url =
                PendingRouteStore.consume()
            {


                router.handle(
                    url:
                        url
                )


            }


        }


    }


}
