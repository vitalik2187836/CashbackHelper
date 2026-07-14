import AppIntents


struct BestCashbackIntent: AppIntent {


    static var title: LocalizedStringResource {
        "Лучший кэшбэк"
    }


    static var description: IntentDescription {
        IntentDescription(
            "Находит пользователя и банк с максимальным кэшбэком по категории"
        )
    }


    @Parameter(
        title: "Категория"
    )
    var category: CategoryEntity



    static var parameterSummary:
        some ParameterSummary {

        Summary(
            "Найти лучший кэшбэк для \(\.$category)"
        )

    }



    func perform() async throws
        -> some IntentResult & ProvidesDialog {


        let result =
            try await CashbackSearchService
                .findBest(
                    category:
                        category.name
                )



        return .result(
            dialog:
            """
            Пользователь: \(result.person.name)
            Банк: \(result.bank.name)
            Категория: \(result.offer.category)
            Кэшбэк: \(result.offer.percent, specifier: "%.0f") процентов
            """
        )


    }


}
