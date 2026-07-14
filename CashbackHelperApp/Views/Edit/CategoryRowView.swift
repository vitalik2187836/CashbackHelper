import SwiftUI
import SwiftData

struct CategoryRowView: View {

    @Bindable
    var record: CashbackRecord

    @Environment(\.modelContext)
    private var context


    var body: some View {

        HStack {

            TextField(
                "Категория",
                text: $record.category
            )
            .textFieldStyle(.plain)


            Spacer()


            TextField(
                "%",
                value: $record.percent,
                format: .number
            )
            .keyboardType(
                .decimalPad
            )
            .multilineTextAlignment(
                .trailing
            )
            .frame(
                width: 60
            )

        }

        .onChange(
            of: record.category
        ) {

            save()

        }


        .onChange(
            of: record.percent
        ) {

            save()

        }

    }


    private func save() {

        try? context.save()

    }
}