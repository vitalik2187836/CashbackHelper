import SwiftUI
import SwiftData


struct BankDetailView: View {


    @Bindable
    var bank: Bank


    @Environment(\.modelContext)
    private var context


    @State
    private var showAddOffer = false


    @State
    private var showEditBank = false


    @State
    private var selectedOffer: CashbackOffer?



    var body: some View {


        List {


            Section(
                "Категории кэшбэка"
            ) {


                ForEach(
                    bank.offers.sorted {
                        $0.percent > $1.percent
                    }
                ) { offer in


                    Button {


                        selectedOffer =
                            offer


                    } label: {


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


                                Spacer()


                                Text(
                                    "\(offer.percent, specifier: "%.0f")%"
                                )
                                .bold()


                            }



                            Text(
                                offer.month.monthTitle
                            )
                            .font(
                                .caption
                            )
                            .foregroundStyle(
                                .secondary
                            )


                        }


                    }
                    .buttonStyle(
                        .plain
                    )


                }


                .onDelete(
                    perform:
                        deleteOffer
                )


            }


        }


        .navigationTitle(
            bank.name
        )


        .toolbar {


            ToolbarItem(
                placement:
                    .topBarLeading
            ) {


                Button {


                    showEditBank = true


                } label: {


                    Image(
                        systemName:
                            "pencil"
                    )


                }


            }



            ToolbarItem(
                placement:
                    .topBarTrailing
            ) {


                Button {


                    showAddOffer = true


                } label: {


                    Image(
                        systemName:
                            "plus"
                    )


                }


            }


        }



        .sheet(
            isPresented:
                $showAddOffer
        ) {


            AddCashbackOfferView(
                bank:
                    bank
            )


        }



        .sheet(
            isPresented:
                $showEditBank
        ) {


            EditBankView(
                bank:
                    bank
            )


        }



        .sheet(
            item:
                $selectedOffer
        ) { offer in


            EditCashbackOfferView(
                offer:
                    offer
            )


        }


    }



    private func deleteOffer(
        offsets:
            IndexSet
    ) {


        let sortedOffers =
            bank.offers.sorted {
                $0.percent > $1.percent
            }



        for index in offsets {


            context.delete(
                sortedOffers[index]
            )


        }



        try? context.save()


    }


}
