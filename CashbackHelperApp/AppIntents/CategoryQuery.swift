import AppIntents
import SwiftData


struct CategoryQuery: EntityQuery {


    @MainActor
    private func context() throws -> ModelContext {

        let container =
            try ModelContainerProvider
                .makeContainer()


        return ModelContext(
            container
        )

    }



    @MainActor
    func suggestedEntities()
    async throws -> [CategoryEntity] {


        let context =
            try context()



        let descriptor =
            FetchDescriptor<CategoryDictionaryItem>(
                sortBy:
                [
                    SortDescriptor(
                        \.name
                    )
                ]
            )



        let items =
            try context.fetch(
                descriptor
            )



        return items.map {


            CategoryEntity(

                id:
                    $0.id,

                name:
                    $0.name

            )


        }


    }




    @MainActor
    func entities(
        for identifiers: [UUID]
    ) async throws -> [CategoryEntity] {


        let context =
            try context()



        let descriptor =
            FetchDescriptor<CategoryDictionaryItem>()



        let items =
            try context.fetch(
                descriptor
            )



        return items

            .filter {

                identifiers.contains(
                    $0.id
                )

            }

            .map {


                CategoryEntity(

                    id:
                        $0.id,

                    name:
                        $0.name

                )


            }


    }




    @MainActor
    func entities(
        matching string: String
    ) async throws -> [CategoryEntity] {


        let context =
            try context()



        let descriptor =
            FetchDescriptor<CategoryDictionaryItem>()



        let items =
            try context.fetch(
                descriptor
            )



        return items

            .filter {


                $0.name
                    .localizedCaseInsensitiveContains(
                        string
                    )


            }

            .map {


                CategoryEntity(

                    id:
                        $0.id,

                    name:
                        $0.name

                )


            }


    }


}
