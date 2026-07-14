import SwiftUI


struct SearchField: View {


    @Binding
    var text: String


    var placeholder: String = "Поиск"



    @FocusState
    private var isFocused: Bool



    var body: some View {


        HStack(
            spacing:
                10
        ) {


            Image(
                systemName:
                    "magnifyingglass"
            )
            .foregroundStyle(
                .secondary
            )



            TextField(
                placeholder,
                text:
                    $text
            )
            .focused(
                $isFocused
            )
            .textFieldStyle(
                .plain
            )
            .submitLabel(
                .search
            )



            if isFocused && !text.isEmpty {


                Button {


                    text = ""

                    isFocused = false

                    hideKeyboard()


                } label: {


                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        .secondary
                    )


                }
                .buttonStyle(
                    .plain
                )
                .transition(
                    .opacity
                )


            }


        }
        .padding(
            .horizontal,
            14
        )
        .padding(
            .vertical,
            12
        )
        .background {


            if #available(
                iOS 26.0,
                *
            ) {


                RoundedRectangle(
                    cornerRadius:
                        16
                )
                .fill(
                    .clear
                )
                .glassEffect(
                    .regular,
                    in:
                        RoundedRectangle(
                            cornerRadius:
                                16
                        )
                )


            } else {


                RoundedRectangle(
                    cornerRadius:
                        16
                )
                .fill(
                    .ultraThinMaterial
                )


            }


        }
        .animation(
            .easeInOut(
                duration:
                    0.2
            ),
            value:
                isFocused
        )
        .animation(
            .easeInOut(
                duration:
                    0.2
            ),
            value:
                text
        )


    }



    private func hideKeyboard() {


        UIApplication.shared
            .sendAction(
                #selector(
                    UIResponder.resignFirstResponder
                ),
                to:
                    nil,
                from:
                    nil,
                for:
                    nil
            )


    }


}
