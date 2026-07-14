import SwiftUI


struct CashbackOfferInputRow: View {
    
    @State
    private var showCategoryPicker = false

    @Bindable
    var draft: CashbackOfferDraft

    @FocusState.Binding
    var focusedField: CashbackFocusField?


    var onDelete: () -> Void



    var body: some View {

        HStack(spacing: 12) {


            HStack(spacing: 8) {


                TextField(
                    "Категория",
                    text: $draft.category
                )
                .focused(
                    $focusedField,
                    equals:
                        .category(
                            draft.id
                        )
                )


                Button {

                    showCategoryPicker = true

                } label: {

                    Image(
                        systemName:
                            "list.star"
                    )

                }
                .sheet(
                    isPresented:
                        $showCategoryPicker
                ) {

                    CategoryPickerView { value in

                        draft.category = value

                    }

                }
                .buttonStyle(
                    .borderless
                )

            }
            .submitLabel(.next)
            .onSubmit {

                focusedField =
                    .percent(
                        draft.id
                    )

            }
            .textFieldStyle(
                .roundedBorder
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 8
                )
                .stroke(
                    draft.categoryInvalid
                        ? Color.red
                        : Color.clear,
                    lineWidth: 1
                )

            }



            TextField(
                "%",
                text: $draft.percent
            )
            .focused(
                $focusedField,
                equals:
                    .percent(
                        draft.id
                    )
            )
            .keyboardType(
                .decimalPad
            )
            .submitLabel(.done)
            .onSubmit {

                focusedField = nil

            }
            
            .multilineTextAlignment(
                .center
            )
            .frame(
                width: 70
            )
            .textFieldStyle(
                .roundedBorder
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 8
                )
                .stroke(
                    draft.percentInvalid
                        ? Color.red
                        : Color.clear,
                    lineWidth: 1
                )

            }



            Button(
                role: .destructive
            ) {

                onDelete()

            } label: {

                Image(
                    systemName: "trash"
                )

            }

        }

    }

}
