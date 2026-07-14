import Foundation


enum PendingRouteStore {


    static let suiteName =
        "group.com.cashbackhelper.shared"



    static var defaults: UserDefaults {

        UserDefaults(
            suiteName:
                suiteName
        )!

    }



    static func save(
        url: URL
    ) {

        defaults.set(
            url.absoluteString,
            forKey:
                "pendingRoute"
        )

    }



    static func consume() -> URL? {


        guard
            let value =
                defaults.string(
                    forKey:
                        "pendingRoute"
                )
        else {

            return nil

        }



        defaults.removeObject(
            forKey:
                "pendingRoute"
        )



        return URL(
            string:
                value
        )

    }


}