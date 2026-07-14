import Foundation


struct FavoriteCategoryResult: Identifiable {

    let id = UUID()

    let category: String

    let bank: String

    let owner: String

    let percent: Double

}