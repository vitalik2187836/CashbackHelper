import UIKit
import SwiftUI
import SwiftData


final class ShareViewController: UIViewController {


    override func viewDidLoad() {

        super.viewDidLoad()


        let model =
            ShareExtensionModel()



        model.extensionContext =
            extensionContext



        model.onSaved = { [weak self] personID, bankID in


            let urlString =
                "cashbackhelper://person/\(personID.uuidString)/bank/\(bankID.uuidString)"



            guard
                let url =
                    URL(
                        string:
                            urlString
                    )
            else {

                return

            }



            DispatchQueue.main.async {


                self?.extensionContext?
                    .open(
                        url
                    ) { success in


                        print(
                            "Open CashbackHelper:",
                            success
                        )



                        self?.extensionContext?
                            .completeRequest(
                                returningItems:
                                    nil
                            )


                    }


            }


        }



        let rootView =
            ShareExtensionView(
                model:
                    model,
                extensionContext:
                    extensionContext
            )
            .modelContainer(
                ShareExtensionContainer.container
            )



        let controller =
            UIHostingController(
                rootView:
                    rootView
            )



        addChild(
            controller
        )


        controller.view.frame =
            view.bounds


        controller.view.autoresizingMask =
        [
            .flexibleWidth,
            .flexibleHeight
        ]



        view.addSubview(
            controller.view
        )


        controller.didMove(
            toParent:
                self
        )

    }


}
