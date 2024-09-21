import Foundation

protocol AlgoDiscoveryViewModelProtocol {
    func goToRepoList(_ repo: String)
}

class AlgoDiscoveryViewModel: AlgoDiscoveryViewModelProtocol {
    private let coordinator: CoordinatorProtocol
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func goToRepoList(_ repo: String) {
        coordinator.list(repo: repo)
    }
}
