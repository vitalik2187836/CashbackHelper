import SwiftUI


struct MonthPickerSheet: View {


    @Binding
    var date: Date


    @Environment(\.dismiss)
    private var dismiss



    var body: some View {


        VStack(spacing: 20) {


            Text(
                "Выберите месяц"
            )
            .font(
                .headline
            )


            MonthPickerCalendar(
                date:
                    $date
            )


            Button(
                "Готово"
            ) {

                date =
                    date.startOfMonth

                dismiss()

            }

        }

        .padding()

    }
}