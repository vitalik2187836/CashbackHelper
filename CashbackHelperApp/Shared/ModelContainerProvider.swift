import Foundation
import SwiftData


enum ModelContainerProvider {


    static let appGroupID =
        "group.com.cashbackhelper.shared"



    static var containerURL: URL {


        FileManager.default
            .containerURL(
                forSecurityApplicationGroupIdentifier:
                    appGroupID
            )!
            .appending(
                path:
                    "CashbackHelper.store"
            )


    }



    static func makeContainer() throws -> ModelContainer {


        let schema =
        Schema(
            [
                Person.self,
                Bank.self,
                CashbackOffer.self,
                AppMonth.self,
                CategoryDictionaryItem.self
            ]
        )


        let configuration =
        ModelConfiguration(
            schema:
                schema,
            url:
                containerURL
        )


        return try ModelContainer(
            for:
                schema,
            configurations:
                [configuration]
        )


    }


}