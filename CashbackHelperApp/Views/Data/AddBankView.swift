import SwiftData
import SwiftUI


struct AddBankView: View {


    let owner: Person


    @Environment(\.dismiss)
    private var dismiss


    @Environment(\.modelContext)
    private var context


    @State
    private var bankName = ""



    var body: some View {


        NavigationStack {


            Form {


                TextField(
                    "Название банка",
                    text:
                        $bankName
                )

            }


            .navigationTitle(
                "Новый банк"
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
                        bankName.trimmingCharacters(
                            in:
                                .whitespacesAndNewlines
                        )


                        guard !value.isEmpty
                        else {
                            return
                        }


                        let bank =
                        Bank(
                            name: value,
                            owner: owner
                        )

                        context.insert(bank)

                        owner.banks.append(bank)

                        try? context.save()


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
