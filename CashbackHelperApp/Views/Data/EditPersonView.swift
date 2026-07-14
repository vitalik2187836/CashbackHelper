import SwiftUI
import SwiftData


struct EditPersonView: View {


    @Bindable
    var person: Person


    @Environment(\.dismiss)
    private var dismiss


    @Environment(\.modelContext)
    private var context


    @State
    private var name = ""



    var body: some View {


        NavigationStack {


            Form {


                Section(
                    "Имя"
                ) {


                    TextField(
                        "Имя",
                        text:
                            $name
                    )


                }


            }


            .navigationTitle(
                "Редактирование"
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



                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {


                    Button(
                        "Сохранить"
                    ) {


                        save()


                    }


                }


            }


            .onAppear {


                name =
                    person.name


            }


        }


    }



    private func save() {


        person.name =
            name.trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )


        try? context.save()


        dismiss()


    }


}