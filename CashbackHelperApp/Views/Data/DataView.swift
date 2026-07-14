import SwiftUI
import SwiftData


struct DataView: View {


    @Environment(\.modelContext)
    private var context


    @Environment(AppRouter.self)
    private var router



    @Query(
        sort:
            \Person.name
    )
    private var persons: [Person]



    @State
    private var showAddPerson = false


    @State
    private var selectedPerson: Person?



    var body: some View {


        NavigationStack {


            List {


                ForEach(
                    persons
                ) { person in


                    NavigationLink {


                        PersonDetailView(
                            person:
                                person
                        )


                    } label: {


                        Text(
                            person.name
                        )


                    }


                }


                .onDelete(
                    perform:
                        deletePerson
                )


            }


            .navigationTitle(
                "Данные"
            )


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
                                "plus"
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


        }


        .navigationDestination(
            item:
                $selectedPerson
        ) { person in


            PersonDetailView(
                person:
                    person
            )


        }



        .onAppear {


            openPersonIfNeeded()


        }



        .onChange(
            of:
                router.destination
        ) { _, _ in


            openPersonIfNeeded()


        }


    }



    private func openPersonIfNeeded() {


        guard

            case let .bank(
                personID,
                _
            ) = router.destination

        else {

            return

        }



        guard

            let person =
                persons.first(
                    where: {
                        $0.id == personID
                    }
                )

        else {

            return

        }



        DispatchQueue.main.async {


            selectedPerson =
                person


        }


    }



    private func deletePerson(
        offsets:
            IndexSet
    ) {


        for index in offsets {


            context.delete(
                persons[index]
            )


        }


        try? context.save()


    }


}
