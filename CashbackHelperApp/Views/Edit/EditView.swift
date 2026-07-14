import SwiftUI
import SwiftData

struct EditView: View {


    @Query(sort: \Person.name)
    private var persons: [Person]


    @Environment(\.modelContext)
    private var context


    @State
    private var showAddPerson = false


    @State
    private var selectedPerson: Person?



    var body: some View {


        NavigationStack {


            List {


                ForEach(persons) { person in


                    Section {


                        ForEach(person.banks) { bank in


                            NavigationLink {


                                BankDetailView(
                                    bank: bank
                                )


                            } label: {


                                Label(
                                    bank.name,
                                    systemImage:
                                        "creditcard"
                                )

                            }

                        }


                    } header: {


                        HStack {


                            Text(person.name)


                            Spacer()


                            Button {


                                selectedPerson =
                                person


                            } label: {


                                Image(
                                    systemName:
                                        "plus.circle"
                                )

                            }

                        }

                    }

                }

            }

            .navigationTitle("Данные")


            .toolbar {


                ToolbarItem(
                    placement:
                        .topBarTrailing
                ) {


                    Button {


                        showAddPerson = true


                    } label: {


                        Image(
                            systemName:
                                "person.badge.plus"
                        )

                    }

                }

            }


            .sheet(
                isPresented:
                    $showAddPerson
            ) {


                AddPersonView()

            }


            .sheet(
                item:
                    $selectedPerson
            ) { person in


                AddBankView(
                    owner: person
                )

            }


        }

    }
}