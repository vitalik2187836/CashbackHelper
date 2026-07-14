import SwiftUI
import SwiftData


struct AddCashbackOfferView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var context


    let bank: Bank


    @State
    private var month = Date()


    @State
    private var drafts: [CashbackOfferDraft] = [
        CashbackOfferDraft()
    ]
    
    @FocusState
    private var focusedField: CashbackFocusField?


    var body: some View {

        NavigationStack {

            Form {

                Section {

                    MonthPickerView(
                        date: $month
                    )

                }

                Section("Категории") {


                    ForEach(drafts) { draft in

                        CashbackOfferInputRow(
                            draft: draft,
                            focusedField: $focusedField
                        ) {

                            removeDraft(
                                draft.id
                            )

                        }

                    

                    }



                    Button {

                        addDraft()

                    } label: {

                        Label(
                            "Добавить строку",
                            systemImage: "plus"
                        )

                    }

                }

            }
            
            .onAppear {

                if let first =
                    drafts.first {

                    DispatchQueue.main.async {

                        focusedField =
                            .category(
                                first.id
                            )

                    }

                }

            }

            .navigationTitle(
                "Кэшбэк"
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

        }

    }



    private func addDraft() {

        let draft =
            CashbackOfferDraft()

        drafts.append(
            draft
        )

        DispatchQueue.main.async {

            focusedField =
                .category(
                    draft.id
                )

        }

    }


    private func removeDraft(
        _ id: UUID
    ) {

        guard drafts.count > 1 else {
            return
        }


        drafts.removeAll {

            $0.id == id

        }

    }



    private var canSave: Bool {

        drafts.allSatisfy {

            $0.isValid

        }

    }



    private func save() {


        for draft in drafts {

            draft.isValidated = true

        }


        guard canSave else {

            return

        }



        for draft in drafts {


            let percent =
                Double(
                    draft.percent
                        .replacingOccurrences(
                            of: ",",
                            with: "."
                        )
                ) ?? 0



            let offer =
                CashbackOffer(

                    month:
                        month.startOfMonth,

                    category:
                        draft.category
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            ),

                    percent:
                        percent,

                    bank:
                        bank

                )



            context.insert(
                offer
            )


            bank.offers.append(
                offer
            )

        }



        do {

            try context.save()

            dismiss()

        } catch {

            print(
                error.localizedDescription
            )

        }

    }

}
