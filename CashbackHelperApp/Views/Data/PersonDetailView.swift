import SwiftUI
import SwiftData


struct PersonDetailView: View {


    @Bindable
    var person: Person


    @Environment(\.modelContext)
    private var context


    @Environment(AppRouter.self)
    private var router



    @State
    private var showAddBank = false


    @State
    private var showEditPerson = false


    @State
    private var selectedBank: Bank?



    var body: some View {


        List {


            Section(
                "Банки"
            ) {


                ForEach(
                    person.banks.sorted {
                        $0.name < $1.name
                    }
                ) { bank in


                    NavigationLink {


                        BankDetailView(
                            bank:
                                bank
                        )


                    } label: {


                        Text(
                            bank.name
                        )


                    }


                }


                .onDelete(
                    perform:
                        deleteBank
                )


            }


        }


        .navigationTitle(
            person.name
        )


        .toolbar {


            ToolbarItem(
                placement:
                    .topBarLeading
            ) {


                Button {


                    showEditPerson = true


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


                    showAddBank = true


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
                $showAddBank
        ) {


            AddBankView(
                owner:
                    person
            )


        }



        .sheet(
            isPresented:
                $showEditPerson
        ) {


            EditPersonView(
                person:
                    person
            )


        }



        .navigationDestination(
            item:
                $selectedBank
        ) { bank in


            BankDetailView(
                bank:
                    bank
            )


        }



        .onAppear {


            openBankIfNeeded()


        }



        .onChange(
            of:
                router.destination
        ) { _, _ in


            openBankIfNeeded()


        }


    }



    private func openBankIfNeeded() {


        guard

            case let .bank(
                personID,
                bankID
            ) = router.destination,

            personID == person.id

        else {

            return

        }



        guard

            let bank =
                person.banks.first(
                    where: {
                        $0.id == bankID
                    }
                )

        else {

            return

        }



        DispatchQueue.main.async {


            selectedBank =
                bank


            router.clear()


        }


    }



    private func deleteBank(
        offsets:
            IndexSet
    ) {


        let sortedBanks =
            person.banks.sorted {
                $0.name < $1.name
            }



        for index in offsets {


            context.delete(
                sortedBanks[index]
            )


        }



        try? context.save()


    }


}
