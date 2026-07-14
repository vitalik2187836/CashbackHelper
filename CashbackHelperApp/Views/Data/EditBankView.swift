import SwiftUI
import SwiftData


struct EditBankView: View {


    @Bindable
    var bank: Bank


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
                    "Название банка"
                ) {


                    TextField(
                        "Банк",
                        text:
                            $name
                    )


                }


            }


            .navigationTitle(
                "Редактирование банка"
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
                    bank.name


            }


        }


    }



    private func save() {


        let value =
            name.trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )


        guard !value.isEmpty else {
            return
        }


        bank.name =
            value


        try? context.save()


        dismiss()


    }


}