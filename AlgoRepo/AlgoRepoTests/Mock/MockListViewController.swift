import Foundation
import UIKit
@testable import AlgoRepo

final class MockListViewController {
    private var data: [GitHubCollectionModel] = []
    private var viewModel : any AlgoRepoListViewModelProtocol
    private(set) var searchExecuted: Bool = false
    
    var dataLoaded: (([GitHubCollectionModel] ) -> Void)?
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = viewModel
        sc.delegate = viewModel
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search repo"
        return sc
    }()
    
    init(viewModel: any AlgoRepoListViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.viewModel.fetchRepo()
    }
}

extension MockListViewController: ViewControllerDelegate {
    func reload(_ data: [GitHubCollectionModel]) {
        self.data = data
        dataLoaded?(data)
    }
    
    func search(_ text: String) {
        searchController.searchBar.text = text
        searchExecuted = true
    }
}
