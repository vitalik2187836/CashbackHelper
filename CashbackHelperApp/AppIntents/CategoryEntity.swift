import AppIntents


struct CategoryEntity:
    AppEntity,
    Identifiable {



    static var typeDisplayRepresentation:
        TypeDisplayRepresentation {

        "Категория"

    }



    var id:
        UUID



    var name:
        String



    init(
        id: UUID,
        name: String
    ) {

        self.id = id
        self.name = name

    }



    static var defaultQuery:
        CategoryQuery {

        CategoryQuery()

    }



    var displayRepresentation:
        DisplayRepresentation {


        DisplayRepresentation(

            title:
                "\(name)"

        )


    }


}
