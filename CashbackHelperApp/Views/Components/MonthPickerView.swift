import SwiftUI


struct MonthPickerView: View {

    @Binding
    var date: Date

    @State
    private var showWheel = false


    var body: some View {

        HStack {

            Text("Месяц")
                .foregroundStyle(.primary)


            Spacer()


            HStack(spacing: 4) {


                Button {

                    changeMonth(-1)

                } label: {

                    Image(
                        systemName: "chevron.left"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.gray)
                    .frame(
                        width: 28,
                        height: 28
                    )

                }
                .buttonStyle(.plain)



                Button {
                    showWheel = true
                } label: {
                    Text(date.monthTitle)
                        .frame(width: 150)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.tint)
                }



                Button {

                    changeMonth(1)

                } label: {

                    Image(
                        systemName: "chevron.right"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.gray)
                    .frame(
                        width: 28,
                        height: 28
                    )

                }
                .buttonStyle(.plain)

            }

        }

        .sheet(
            isPresented:
                $showWheel
        ) {

            MonthWheelPicker(
                date:
                    $date
            )
            .presentationDetents(
                [
                    .height(320)
                ]
            )
            .presentationDragIndicator(
                .visible
            )
        }
    }



    private func changeMonth(
        _ value: Int
    ) {

        guard let newDate =
                Calendar.current.date(
                    byAdding: .month,
                    value: value,
                    to: date
                )
        else {
            return
        }


        let normalized =
            newDate.startOfMonth


        if normalized <= Date.nextMonth {

            date = normalized

        }
    }
}
