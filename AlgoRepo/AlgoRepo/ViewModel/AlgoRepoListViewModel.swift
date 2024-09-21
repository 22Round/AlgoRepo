import Foundation
import UIKit

protocol AlgoRepoListViewModelProtocol: UISearchResultsUpdating, UISearchControllerDelegate{
    var delegate: (any ViewControllerDelegate)? { get set }
    func goToDetails(model: GitHubCollectionModel)
    func fetchRepo()
    func makeFavorite(id: Int)
}

class AlgoRepoListViewModel: NSObject, AlgoRepoListViewModelProtocol {
    private let coordinator : CoordinatorProtocol
    private let domain: AlgoRepoListDomainProtocol
    private var search: String?
    
    weak var delegate: (any ViewControllerDelegate)?
    
    init(coordinator: CoordinatorProtocol, domain: AlgoRepoListDomainProtocol) {
        self.coordinator = coordinator
        self.domain = domain
    }
    
    func goToDetails(model: GitHubCollectionModel) {
        coordinator.safari(url: model.htmlUrl)
    }
    
    func fetchRepo() {
        Task.detached(priority: .background) { [weak self] in
            guard let result = await self?.domain.fetchRepo() else { return }
            Task { @MainActor [weak self] in
                self?.delegate?.reload(result)
            }
        }
    }
    
    func makeFavorite(id: Int) {
        Task(priority: .background) {
            await domain.makeFavorite(id: id)
            await search(search)
        }
    }
    
    private func search(_ text: String?) async {
        guard let data = domain.getData else { return }
        var result: [GitHubCollectionModel]
        if let search = text, !search.isEmpty {
            result = data.filter {
                $0.name.localizedCaseInsensitiveContains(search) ||
                ($0.description?.localizedCaseInsensitiveContains(search) ?? false)
            }
        } else {
            result = data
        }
        delegate?.reload(result)
    }
}

extension AlgoRepoListViewModel {
    func updateSearchResults(for searchController: UISearchController) {
        search = searchController.searchBar.text
        Task(priority: .background) {
            await search(search)
        }
    }
}
