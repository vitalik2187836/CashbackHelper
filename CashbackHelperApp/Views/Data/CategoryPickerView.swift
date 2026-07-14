import SwiftUI
import SwiftData


struct CategoryPickerView: View {


    @Environment(\.dismiss)
    private var dismiss


    @Query(
        sort:
            \CategoryDictionaryItem.name
    )
    private var categories: [CategoryDictionaryItem]


    var onSelect: (String) -> Void



    var body: some View {


        NavigationStack {


            List {


                ForEach(
                    categories
                ) { category in


                    Button {


                        onSelect(
                            category.name
                        )


                        dismiss()


                    } label: {


                        HStack {


                            Text(
                                category.name
                            )


                            Spacer()


                            if category.isFavorite {


                                Image(
                                    systemName:
                                        "star.fill"
                                )
                                .foregroundStyle(
                                    .yellow
                                )

                            }

                        }

                    }

                }

            }

            .navigationTitle(
                "Категории"
            )

            .toolbar {


                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {


                    Button(
                        "Отмена"
                    ) {


                        dismiss()

                    }

                }

            }

        }

    }

}