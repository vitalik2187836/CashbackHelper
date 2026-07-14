import Foundation


struct ExportData: Codable {

    var persons: [ExportPerson]

}


struct ExportPerson: Codable {

    var name: String

    var banks: [ExportBank]

}


struct ExportBank: Codable {

    var name: String

    var offers: [ExportOffer]

}


struct ExportOffer: Codable {

    var month: Date

    var category: String

    var percent: Double

}
