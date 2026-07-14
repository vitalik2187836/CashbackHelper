import SwiftUI
import SwiftData

struct EditCashbackOfferView: View {

    @Bindable
    var offer: CashbackOffer

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var context

    @State
    private var category = ""

    @State
    private var percent = ""

    var body: some View {

        NavigationStack {

            Form {

                Section(
                    "Категория"
                ) {

                    TextField(
                        "Категория",
                        text:
                            $category
                    )

                }

                Section(
                    "Процент"
                ) {

                    TextField(
                        "%",
                        text:
                            $percent
                    )
                    .keyboardType(
                        .decimalPad
                    )

                }

                Section(
                    "Месяц"
                ) {

                    Text(
                        offer.month.monthTitle
                    )
                    .foregroundStyle(
                        .secondary
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

                category =
                    offer.category

                percent =
                    String(
                        format:
                            "%.0f",
                        offer.percent
                    )

            }

        }

    }

    private func save() {

        let newCategory =
            category.trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )

        guard !newCategory.isEmpty else {
            return
        }

        let newPercent =
            Double(
                percent.replacingOccurrences(
                    of:
                        ",",
                    with:
                        "."
                )
            ) ?? 0

        offer.category =
            newCategory

        offer.searchCategory =
            CashbackOffer.normalize(
                newCategory
            )

        offer.percent =
            newPercent

        try? context.save()

        dismiss()

    }

}
