import SwiftUI


struct CashbackOfferRow: View {


    let offer: CashbackOffer



    var body: some View {


        VStack(
            alignment:
                .leading,
            spacing:
                6
        ) {


            HStack {


                Text(
                    offer.category
                )
                .font(
                    .headline
                )


                Spacer()


                Text(
                    "\(offer.percent, specifier: "%.0f")%"
                )
                .font(
                    .title3.bold()
                )

            }



            Text(
                offer.bank.name
            )
            .foregroundStyle(
                .secondary
            )



            Text(
                offer.bank.owner.name
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

        }

    }
}