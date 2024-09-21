import Foundation
@testable import AlgoRepo

final class FakeFavoriteRepository: FavoriteRepositoryProtocol {
    var getValue: [Int] {
        [0]
    }
    
    func saveValue(id: Int) {}
    
    func deleteValue(id: Int) {}
}
