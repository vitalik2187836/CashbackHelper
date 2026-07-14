import SwiftUI


struct MonthPickerCalendar: View {


    @Binding
    var date: Date



    var body: some View {


        HStack {


            Button {

                changeMonth(
                    -1
                )

            } label: {

                Image(
                    systemName:
                        "chevron.left"
                )

            }



            Spacer()



            Text(
                date.monthTitle
            )
            .font(
                .title3.bold()
            )



            Spacer()



            Button {

                changeMonth(
                    1
                )

            } label: {

                Image(
                    systemName:
                        "chevron.right"
                )

            }

        }

    }



    private func changeMonth(
        _ value: Int
    ) {

        if let newDate =
            Calendar.current.date(
                byAdding:
                    .month,
                value:
                    value,
                to:
                    date
            ) {

            date = newDate.startOfMonth

        }
    }
}