protocol AlgoRepoListDomainProtocol {
    @discardableResult
    func fetchRepo() async -> [GitHubCollectionModel]?
    func makeFavorite(id: Int) async
    var getData: [GitHubCollectionModel]? { get }
}

class AlgoRepoListDomain: AlgoRepoListDomainProtocol {
    private let service: APIServieProtocol
    private let repository: FavoriteRepositoryProtocol
    private let id: String
    
    private var repoSource: [GitHubCollectionModel]?
    private(set) var errorMessage: ResultError?
    
    init(id: String, repository: FavoriteRepositoryProtocol, service: APIServieProtocol) {
        self.id = id
        self.repository = repository
        self.service = service
    }
    
    var getData: [GitHubCollectionModel]? {
        repoSource
    }
    
    @discardableResult
    nonisolated func fetchRepo() async -> [GitHubCollectionModel]? {
        let result = await service.repo(id)
        switch result {
        case .success(let models):
            let repoList: [GitHubCollectionModel] = models.map { model in
                
                var isFavorite = false
                if !repository.getValue.isEmpty {
                    isFavorite = (repository.getValue.first(where: { $0 == model.id } ) != nil)
                }
                
                return GitHubCollectionModel(
                    id: model.id,
                    name: model.name,
                    description: model.description,
                    htmlUrl: model.htmlUrl,
                    isFavorite: isFavorite)
            }
            repoSource = repoList
            return repoList
            
        case .failure(let error):
            errorMessage = error
        }
        return nil
    }
    
    func makeFavorite(id: Int) async {
        guard let index = repoSource?.firstIndex(where: {$0.id == id}), var model = repoSource?[index] else { return }
        let favorite: Bool = model.isFavorite ? false : true
        model.favorite(favorite)
        
        Task.detached(priority: .background) { [weak self, model, favorite] in
            self?.updateRepo(id: model.id, action: favorite)
        }
        repoSource?[index] = model
    }
    
    nonisolated private func updateRepo(id: Int, action: Bool) {
        if action {
            repository.saveValue(id: id)
        } else {
            repository.deleteValue(id: id)
        }
    }
}
