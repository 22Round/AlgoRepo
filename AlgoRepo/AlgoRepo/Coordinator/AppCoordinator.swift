import UIKit
import SafariServices

class AppCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func safari(url: String) {
        guard let url = URL(string: url) else { return }
        let viewController = SFSafariViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func discovery() {
        let viewModel = AlgoDiscoveryViewModel(coordinator: self)
        let viewController = AlgoDiscoveryViewCintroller(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func list(repo: String) {
        let service: APIService = .init()
        let favoriteRepo = FavoriteRepository()
        let domain = AlgoRepoListDomain(id: repo, repository: favoriteRepo, service: service)
        let viewModel = AlgoRepoListViewModel(coordinator: self, domain: domain)
        let viewController = AlgoRepoListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}

protocol CoordinatorProtocol {
    
    var navigationController : UINavigationController { get set }
    func discovery()
    func list(repo: String)
    func popToRoot()
    func safari(url: String)
}
