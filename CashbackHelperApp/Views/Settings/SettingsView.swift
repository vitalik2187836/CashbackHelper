import SwiftUI
import SwiftData
import UniformTypeIdentifiers


struct SettingsView: View {


    @Query
    private var persons: [Person]


    @Environment(\.modelContext)
    private var context


    @State
    private var showImporter = false


    @State
    private var showImportConfirmation = false


    @State
    private var shareURL: ShareFile?


    @State
    private var importMessage: String?



    var body: some View {


        NavigationStack {


            List {


                Section(
                    "Данные"
                ) {


                    Button {


                        exportData()


                    } label: {


                        Label(
                            "Экспорт данных",
                            systemImage:
                                "square.and.arrow.up"
                        )

                    }



                    Button {


                        showImportConfirmation = true


                    } label: {


                        Label(
                            "Импорт данных",
                            systemImage:
                                "square.and.arrow.down"
                        )

                    }

                }

                Section(
                    "Справочники"
                ) {


                    NavigationLink {


                        CategoryDictionaryView()


                    } label: {


                        Label(
                            "Категории",
                            systemImage:
                                "text.book.closed"
                        )

                    }

                }

                Section(
                    "О приложении"
                ) {


                    VStack(
                        alignment:
                            .leading
                    ) {


                        Text(
                            "Cashback Helper"
                        )
                        .font(
                            .headline
                        )


                        Text(
                            "Помощник выбора карты с максимальным кэшбэком"
                        )
                        .foregroundStyle(
                            .secondary
                        )


                        Text(
                            "Версия 1.0"
                        )
                        .font(
                            .caption
                        )

                    }

                }

            }

            .navigationTitle(
                "Настройки"
            )

        }



        .alert(
            "Импорт данных",
            isPresented:
                $showImportConfirmation
        ) {


            Button(
                "Да",
                role:
                    .destructive
            ) {


                showImporter = true


            }



            Button(
                "Нет",
                role:
                    .cancel
            ) {


            }


        } message: {


            Text(
                "ВСЕ ваши текущие данные заменятся данными из файла. Вы хотите продолжить?"
            )

        }



        .fileImporter(

            isPresented:
                $showImporter,

            allowedContentTypes:
                [.json]

        ) { result in


            switch result {


            case .success(let url):


                do {


                    let access =
                        url.startAccessingSecurityScopedResource()


                    defer {

                        if access {

                            url.stopAccessingSecurityScopedResource()

                        }

                    }



                    let result =
                        try ImportService.importFile(
                            url:
                                url,

                            context:
                                context
                        )



                    context.processPendingChanges()



                    importMessage =
                        """
                        Импорт завершен.

                        Пользователей: \(result.persons)
                        Банков: \(result.banks)
                        Категорий: \(result.offers)
                        """

                }
                catch {


                    importMessage =
                        """
                        Ошибка импорта:

                        \(error.localizedDescription)
                        """

                }



            case .failure(let error):


                importMessage =
                    """
                    Ошибка выбора файла:

                    \(error.localizedDescription)
                    """

            }

        }



        .sheet(
            item:
                $shareURL

        ) { file in


            ShareSheet(
                items:
                    [
                        file.url
                    ]
            )

        }



        .alert(
            "Результат",
            isPresented:
                .constant(importMessage != nil)
        ) {


            Button(
                "OK"
            ) {

                importMessage = nil

            }

        } message: {


            Text(
                importMessage ?? ""
            )

        }

    }



    private func exportData() {


        do {


            let url =
                try ExportService.export(
                    persons:
                        persons
                )


            shareURL =
                ShareFile(
                    url:
                        url
                )


        }
        catch {


            importMessage =
                """
                Ошибка экспорта:

                \(error.localizedDescription)
                """

        }

    }

}



struct ShareFile: Identifiable {


    let id =
        UUID()


    let url: URL

}
