import SwiftUI

struct MonthSelectorView: View {

    @Bindable
    var viewModel: MonthViewModel


    var body: some View {

        HStack {


            Button {

                viewModel.previousMonth()

            } label: {

                Image(
                    systemName:
                        "chevron.left"
                )

            }



            Spacer()



            Text(
                viewModel.title()
            )
            .font(
                .headline
            )



            Spacer()



            Button {

                viewModel.nextMonth()

            } label: {

                Image(
                    systemName:
                        "chevron.right"
                )

            }

        }
        .padding(
            .horizontal
        )

    }
}