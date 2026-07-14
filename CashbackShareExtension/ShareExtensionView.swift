import SwiftUI
import SwiftData


struct ShareExtensionView: View {


    @ObservedObject
    var model: ShareExtensionModel
    let extensionContext: NSExtensionContext?


    @Environment(\.modelContext)
    private var context



    @Environment(\.dismiss)
    private var dismiss

    @Environment(
        \.openURL
    )
    private var openURL



    var body: some View {


        NavigationStack {
            
            
            Form {
                
                
                if let image =
                    model.image {
                    
                    
                    Section(
                        "Изображение"
                    ) {
                        
                        
                        Image(
                            uiImage:
                                image
                        )
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxHeight:
                                180
                        )
                        
                        
                    }
                    
                    
                }
                
                
                
                Section(
                    "Пользователь"
                ) {
                    
                    
                    Picker(
                        "Пользователь",
                        selection:
                            Binding(
                                
                                get: {
                                    
                                    model.selectedPersonID
                                    
                                },
                                
                                set: {
                                    
                                    if let value = $0 {
                                        
                                        model.selectPerson(
                                            value
                                        )
                                        
                                    }
                                    
                                }
                                
                            )
                    ) {
                        
                        
                        ForEach(
                            model.persons
                        ) { person in
                            
                            
                            Text(
                                person.name
                            )
                            .tag(
                                Optional(
                                    person.id
                                )
                            )
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                Section(
                    "Банк"
                ) {
                    
                    
                    Picker(
                        "Банк",
                        selection:
                            $model.selectedBankID
                    ) {
                        
                        
                        ForEach(
                            model.banks.filter {
                                
                                $0.ownerID ==
                                model.selectedPersonID
                                
                            }
                        ) { bank in
                            
                            
                            Text(
                                bank.name
                            )
                            .tag(
                                Optional(
                                    bank.id
                                )
                            )
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                Section(
                    "Категории"
                ) {
                    
                    
                    if model.isRecognizing {
                        
                        
                        HStack {
                            
                            
                            ProgressView()
                            
                            
                            Text(
                                "Распознавание..."
                            )
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    ForEach(
                        model.offers
                    ) { offer in
                        
                        
                        VStack(
                            alignment:
                                    .leading,
                            spacing:
                                8
                        ) {
                            
                            
                            TextField(
                                "Категория",
                                text:
                                    Binding(
                                        
                                        get: {
                                            
                                            offer.category
                                            
                                        },
                                        
                                        set: {
                                            
                                            model.updateOffer(
                                                
                                                id:
                                                    offer.id,
                                                
                                                category:
                                                    $0,
                                                
                                                percent:
                                                    offer.percent
                                                
                                            )
                                            
                                        }
                                        
                                    )
                            )
                            
                            
                            
                            HStack {
                                
                                
                                TextField(
                                    "%",
                                    text:
                                        Binding(
                                            
                                            get: {
                                                
                                                String(
                                                    format:
                                                        "%.0f",
                                                    offer.percent
                                                )
                                                
                                            },
                                            
                                            set: {
                                                
                                                let value =
                                                Double(
                                                    $0.replacingOccurrences(
                                                        of: ",",
                                                        with: "."
                                                    )
                                                )
                                                ?? 0
                                                
                                                
                                                model.updateOffer(
                                                    
                                                    id:
                                                        offer.id,
                                                    
                                                    category:
                                                        offer.category,
                                                    
                                                    percent:
                                                        value
                                                    
                                                )
                                                
                                            }
                                            
                                        )
                                )
                                .keyboardType(
                                    .decimalPad
                                )
                                .frame(
                                    width:
                                        80
                                )
                                
                                
                                Spacer()
                                
                                
                                
                                Button(
                                    role:
                                            .destructive
                                ) {
                                    
                                    
                                    model.removeOffer(
                                        id:
                                            offer.id
                                    )
                                    
                                    
                                } label: {
                                    
                                    
                                    Image(
                                        systemName:
                                            "trash"
                                    )
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    if model.offers.isEmpty
                        && !model.isRecognizing {
                        
                        
                        ContentUnavailableView(
                            
                            "Категории не найдены",
                            
                            systemImage:
                                "doc.text.viewfinder"
                            
                        )
                        
                        
                    }
                    
                    
                }
                
                
                
                if let error =
                    model.errorMessage {
                    
                    
                    Section {
                        
                        
                        Text(
                            error
                        )
                        .foregroundStyle(
                            .red
                        )
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            .navigationTitle(
                "Импорт данных"
            )
            .toolbar {


                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {


                    Button(
                        "Отмена"
                    ) {


                        model.clear()


                    }


                }



                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {


                    Button(
                        "Добавить"
                    ) {


                        model.save()


                    }
                    .disabled(
                        !model.canSave
                    )


                }


            }


            .onChange(
                of:
                    model.saveCompleted
            ) {


                _, completed in


                guard completed else {
                    return
                }


                closeExtension()


            }



            .task {

                model.extensionContext =
                    extensionContext


                model.configure(
                    context:
                        context
                )

                model.load(
                    from: extensionContext
                )

            }


        }


    }



    private func closeExtension() {

        DispatchQueue.main.async {

            extensionContext?
                .completeRequest(
                    returningItems:
                        nil
                )

        }

    }
}
