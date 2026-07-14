import SwiftData
import SwiftUI


struct AddPersonView: View {


    @Environment(\.dismiss)
    private var dismiss


    @Environment(\.modelContext)
    private var context


    @State
    private var name = ""



    var body: some View {


        NavigationStack {


            Form {


                TextField(
                    "Имя",
                    text:
                        $name
                )


            }


            .navigationTitle(
                "Новый пользователь"
            )


            .toolbar {


                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {


                    Button(
                        "Сохранить"
                    ) {


                        let value =
                        name.trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )


                        guard !value.isEmpty
                        else {
                            return
                        }


                        let person =
                        Person(
                            name:
                                value
                        )


                        context.insert(
                            person
                        )


                        try? context.save()


                        dismiss()

                    }

                }



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
