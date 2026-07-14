import Foundation
import Observation

@Observable
final class AppState {

    var alertTitle = ""
    var alertMessage = ""
    var showAlert = false


    func showError(
        title: String,
        message: String
    ) {

        alertTitle = title
        alertMessage = message
        showAlert = true

    }


    func showInfo(
        title: String,
        message: String
    ) {

        alertTitle = title
        alertMessage = message
        showAlert = true

    }
}
