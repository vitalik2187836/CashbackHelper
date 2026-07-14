import SwiftUI
import SwiftData


struct CategoryDictionaryView: View {


    @Environment(\.modelContext)
    private var context


    @Query(
        sort:
            \CategoryDictionaryItem.name
    )
    private var categories: [CategoryDictionaryItem]


    @State
    private var newCategory = ""



    var body: some View {


        List {


            Section {


                HStack {


                    TextField(
                        "Новая категория",
                        text:
                            $newCategory
                    )


                    Button {


                        addCategory()


                    } label: {


                        Image(
                            systemName:
                                "plus"
                        )

                    }

                }

            }



            Section {


                ForEach(
                    categories
                ) { category in


                    HStack {


                        Text(
                            category.name
                        )


                        Spacer()


                        Toggle(
                            "Избранное",
                            isOn:
                                Bindable(
                                    category
                                ).isFavorite
                        )
                        .labelsHidden()


                    }

                }

                .onDelete(
                    perform:
                        delete
                )

            }

        }

        .navigationTitle(
            "Категории"
        )

    }



    private func addCategory() {

        let value =
            newCategory
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )


        guard !value.isEmpty else {
            return
        }


        context.insert(
            CategoryDictionaryItem(
                name:
                    value
            )
        )


        newCategory = ""

    }



    private func delete(
        offsets: IndexSet
    ) {

        for index in offsets {

            context.delete(
                categories[index]
            )

        }

    }

}
