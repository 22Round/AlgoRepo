import XCTest
@testable import AlgoRepo

final class AlgoRepoTests: XCTestCase {
    private let coordinator = AppCoordinator(navigationController: UINavigationController())
    
    private let service = FakeAPIService(network: FakeNetworkService(dummy: "List"))
    private let repo = FakeFavoriteRepository()

    var data: [GitHubCollectionModel]?

    override func setUpWithError() throws {
        data = nil
    }

    func testDataFetch() throws {
        
        let exp = expectation(description: "Loading data")
        
        let domain = AlgoRepoListDomain(id: "1", repository: repo, service: service)
        let viewModel = AlgoRepoListViewModel(coordinator: coordinator, domain: domain)
        let sut = MockListViewController(viewModel: viewModel)
        
        sut.dataLoaded = { [weak self] source in
            self?.data = source
            exp.fulfill()
        }
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(data)
        XCTAssertFalse(data?.isEmpty ?? true)
    }
    
    func testSearch() throws {
        
        let exp = expectation(description: "Loading data and search")
        
        let domain = AlgoRepoListDomain(id: "1", repository: repo, service: service)
        let viewModel = AlgoRepoListViewModel(coordinator: coordinator, domain: domain)
        
        let sut = MockListViewController(viewModel: viewModel)
        let search = "pera"

        sut.dataLoaded = { [weak self] source in
            self?.data = source
            if sut.searchExecuted {
                exp.fulfill()
            } else {
                sut.search(search)
            }
        }
        waitForExpectations(timeout: 2)

        XCTAssertNotNil(data)
        XCTAssertFalse(data?.isEmpty ?? true)
        XCTAssertTrue(searchFound(text: search, data: data))
    }
    
    func testServerError() async throws {
        let fakeErrorService: FakeNetworkErrorService = .init(error: .badURL)
        let faleService = FakeAPIService(network: fakeErrorService)
        
        let sut = AlgoRepoListDomain(id: "1", repository: repo, service: faleService)
        await sut.fetchRepo()
        
        XCTAssertEqual(sut.errorMessage, .badURL)
    }
    
    private func searchFound(text: String, data: [GitHubCollectionModel]?) -> Bool {
        guard let  data = data, !data.isEmpty else { return false }
        
        let charset = CharacterSet(charactersIn: text)
        for item in data {
            if let desc = item.description?.lowercased(), 
                item.name.lowercased().rangeOfCharacter(from: charset) != nil ||
                desc.rangeOfCharacter(from: charset) != nil {
                
                return true
            }
        }
        
        return false
    }
}
