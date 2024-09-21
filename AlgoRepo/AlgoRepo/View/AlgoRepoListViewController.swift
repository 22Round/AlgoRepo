import UIKit

protocol ViewControllerDelegate: AnyObject {
    func reload(_ data: [GitHubCollectionModel])
}

class AlgoRepoListViewController: UIViewController {
    
    private let cellID: String = "cellID"
    fileprivate var viewModel : any AlgoRepoListViewModelProtocol
    fileprivate var data: [GitHubCollectionModel] = []
    fileprivate let activityView = UIActivityIndicatorView(style: .large)


    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlgoCollectionCellView.self, forCellWithReuseIdentifier: cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchRepo()
        
        layoutView(collectionView)
        
        view.addSubview(activityView)
        activityView.tintColor = .gray
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Repositories"
    }
    
    private func layoutView(_ source: UIView) {
        view.addSubview(source)
        NSLayoutConstraint.activate([
            source.topAnchor.constraint(equalTo: view.topAnchor),
            source.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            source.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            source.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AlgoRepoListViewController: ViewControllerDelegate {
    func reload(_ data: [GitHubCollectionModel]) {
        self.data = data
        collectionView.reloadData()
        activityView.removeFromSuperview()
    }
}

extension AlgoRepoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data[indexPath.item]
        viewModel.goToDetails(model: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? AlgoCollectionCellView {
            let data = self.data[indexPath.item]
            cell.callBack = { [weak self] in
                self?.viewModel.makeFavorite(id: data.id)
            }
            cell.setupView(model: data)
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}

extension AlgoRepoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth, height: 60)
    }
}
