import Foundation


struct ParsedCashbackOffer: Identifiable {

    let id =
        UUID()

    var category: String

    var percent: Double

}