import SwiftUI
import SwiftData


struct SearchView: View {


    @Environment(\.modelContext)
    private var context


    @State
    private var query = ""


    @State
    private var selectedMonth = Date()



    @Query(
        sort: [
            SortDescriptor(
                \CashbackOffer.percent,
                order: .reverse
            )
        ]
    )
    private var offers: [CashbackOffer]



    @Query(
        sort:
            \CategoryDictionaryItem.name
    )
    private var dictionaryCategories: [CategoryDictionaryItem]



    private var filteredOffers: [CashbackOffer] {


        let normalized =
            CashbackOffer.normalize(
                query
            )


        if normalized.isEmpty {

            return []

        }


        return offers
            .filter {


                $0.searchCategory.contains(
                    normalized
                )
                &&
                Calendar.current.isDate(
                    $0.month,
                    equalTo:
                        selectedMonth.startOfMonth,
                    toGranularity:
                        .month
                )


            }
            .sorted {


                $0.percent > $1.percent


            }

    }



    private var favoriteResults: [FavoriteCategoryResult] {


        let favoriteNames =
            Set(
                dictionaryCategories
                    .filter {
                        $0.isFavorite
                    }
                    .map {
                        $0.name
                    }
            )


        let currentMonthOffers =
            offers.filter {


                favoriteNames.contains(
                    $0.category
                )
                &&
                Calendar.current.isDate(
                    $0.month,
                    equalTo:
                        selectedMonth.startOfMonth,
                    toGranularity:
                        .month
                )


            }



        let grouped =
            Dictionary(
                grouping:
                    currentMonthOffers,
                by:
                    \.category
            )



        return grouped.compactMap { category, offers in


            guard let bestOffer =
                    offers.max(
                        by:
                            {
                                $0.percent < $1.percent
                            }
                    )
            else {

                return nil

            }



            return FavoriteCategoryResult(

                category:
                    category,

                bank:
                    bestOffer.bank.name,

                owner:
                    bestOffer.bank.owner.name,

                percent:
                    bestOffer.percent

            )

        }
        .sorted {

            $0.percent > $1.percent

        }

    }



    var body: some View {


        NavigationStack {


            VStack {


                TextField(
                    "Категория",
                    text:
                        $query
                )
                .textFieldStyle(
                    .roundedBorder
                )
                .padding()



                MonthPickerView(
                    date:
                        $selectedMonth
                )
                .padding(
                    .horizontal
                )



                List {


                    if !filteredOffers.isEmpty {


                        ForEach(
                            filteredOffers
                        ) { offer in


                            CashbackOfferRow(
                                offer:
                                    offer
                            )

                        }


                    }
                    else if query.isEmpty &&
                            !favoriteResults.isEmpty {


                        ForEach(
                            favoriteResults
                        ) { item in


                            VStack(
                                alignment:
                                    .leading,
                                spacing:
                                    6
                            ) {


                                HStack {


                                    Image(
                                        systemName:
                                            "star.fill"
                                    )
                                    .foregroundStyle(
                                        .yellow
                                    )


                                    Text(
                                        item.category
                                    )
                                    .font(
                                        .headline
                                    )


                                }



                                Text(
                                    "\(item.bank) • \(item.owner)"
                                )
                                .foregroundStyle(
                                    .secondary
                                )



                                Text(
                                    "\(item.percent, specifier: "%.0f")%"
                                )
                                .font(
                                    .title3
                                )


                            }

                        }


                    }
                    else {


                        ContentUnavailableView(
                            "Нет данных",
                            systemImage:
                                "magnifyingglass"
                        )


                    }

                }


            }


            .navigationTitle(
                "Поиск"
            )

        }

    }

}
