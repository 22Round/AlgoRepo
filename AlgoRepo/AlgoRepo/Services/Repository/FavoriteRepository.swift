import Foundation

protocol FavoriteRepositoryProtocol {
    var getValue: [Int] { get }
    func saveValue(id: Int)
    func deleteValue(id: Int)
}
class FavoriteRepository: FavoriteRepositoryProtocol {
    private let key: String = "favoritesUserDefaults"
    private var repo: [Int]? {
        get { UserDefaults.standard.array(forKey: key) as? [Int] }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
    
    var getValue: [Int] {
        repo ?? []
    }
    
    func saveValue(id: Int) {
        var local = getValue
        local.append(id)
        let unique = Array(Set(local))
        repo = unique
    }
    
    func deleteValue(id: Int) {
        var local = getValue
        if let index = local.firstIndex(of: id) {
            local.remove(at: index)
        }
        repo = local
    }
}
