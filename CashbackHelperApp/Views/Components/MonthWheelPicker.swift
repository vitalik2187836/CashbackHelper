import SwiftUI


struct MonthWheelPicker: View {

    @Binding
    var date: Date

    @Environment(\.dismiss)
    private var dismiss


    @State
    private var selectedMonth: Int

    @State
    private var selectedYear: Int


    private var availableMonths: [Int] {

        let calendar =
            Calendar.current

        let maxDate =
            Date.nextMonth


        let maxYear =
            calendar.component(
                .year,
                from: maxDate
            )

        let maxMonth =
            calendar.component(
                .month,
                from: maxDate
            )


        if selectedYear < maxYear {

            return Array(1...12)

        }


        return Array(1...maxMonth)
    }


    private var years: [Int] {

        let calendar =
            Calendar.current


        let currentYear =
            calendar.component(
                .year,
                from:
                    Date()
            )


        let maxYear =
            calendar.component(
                .year,
                from:
                    Date.nextMonth
            )


        return Array(
            (currentYear - 10)...maxYear
        )
    }

    init(
        date: Binding<Date>
    ) {

        _date = date

        let calendar =
            Calendar.current

        let components =
            calendar.dateComponents(
                [
                    .month,
                    .year
                ],
                from: date.wrappedValue
            )


        _selectedMonth =
            State(
                initialValue:
                    components.month ?? 1
            )

        _selectedYear =
            State(
                initialValue:
                    components.year ?? 2026
            )
    }



    var body: some View {


        VStack(spacing: 10) {


            Text(
                "Выберите месяц"
            )
            .font(
                .headline
            )


            HStack {


                Picker(
                    "Месяц",
                    selection:
                        $selectedMonth
                ) {


                    ForEach(
                        availableMonths,
                        id:
                            \.self
                    ) { month in


                        Text(
                            monthName(
                                month
                            )
                        )
                        .tag(
                            month
                        )

                    }

                }


                .pickerStyle(
                    .wheel
                )



                Picker(
                    "Год",
                    selection:
                        $selectedYear
                ) {


                    ForEach(
                        years,
                        id:
                            \.self
                    ) { year in


                        Text(
                            String(year)
                        )
                        .tag(
                            year
                        )

                    }

                }


                .pickerStyle(
                    .wheel
                )

            }


            Button(
                "Готово"
            ) {


                var components =
                    DateComponents()

                components.month =
                    selectedMonth

                components.year =
                    selectedYear

                date =
                    Calendar.current
                        .date(
                            from:
                                components
                        )?
                        .startOfMonth
                    ?? date


                dismiss()

            }

        }

        .padding()
        
        .onChange(
            of: selectedYear
        ) {

            if !availableMonths.contains(
                selectedMonth
            ) {

                selectedMonth =
                    availableMonths.last ?? 1
            }
        }

    }



    private func monthName(
        _ number: Int
    ) -> String {


        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier:
                    "ru_RU"
            )

        return formatter.monthSymbols[
            number - 1
        ]

        .capitalized

    }
}
