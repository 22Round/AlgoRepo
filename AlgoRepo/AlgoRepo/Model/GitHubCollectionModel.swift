import Foundation

struct GitHubCollectionModel: Identifiable {
    let id: Int
    let name: String
    let description: String?
    let htmlUrl: String
    var isFavorite: Bool
    
    mutating func favorite(_ favorite: Bool) {
        isFavorite = favorite
    }
}
