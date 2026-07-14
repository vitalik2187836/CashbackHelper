import AppIntents


struct CashbackHelperShortcuts: AppShortcutsProvider {


    static var appShortcuts: [AppShortcut] {


        AppShortcut(

            intent:
                BestCashbackIntent(),

            phrases:
            [
                "Какой лучший кэшбэк в \(.applicationName) для \(\.$category)",

                "Найди лучший кэшбэк в \(.applicationName) для \(\.$category)",

                "Где максимальный кэшбэк в \(.applicationName) для \(\.$category)"
            ],

            shortTitle:
                "Лучший кэшбэк",

            systemImageName:
                "creditcard"

        )

    }

}
