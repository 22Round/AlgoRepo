import Foundation

protocol APIServieProtocol {
    func repo(_ repo: String) async -> Result<[GitHubResponseModel], ResultError>
}

class APIService: APIServieProtocol {
    private let networkSetvice: NetworkService = .init()
    
    func repo(_ repo: String) async -> Result<[GitHubResponseModel], ResultError> {
        let request = GitHubAPIRequestProvider(service: .repos(repo), method: .get)
        
        do {
            let result = try await fetch(type: [GitHubResponseModel].self, request: request)
            return .success(result)
            
        } catch (let error) {
            return .failure((error as? ResultError) ?? .unknown)
        }
    }

    private func fetch<T: Decodable>(type: T.Type, request: RequestProviderProtocol) async throws -> T {
        let result = await networkSetvice.fetchData(request: request)
        switch result {
        case .success(let dataLoaded):
            let parsedResult = await Parser().parseJSON(json: dataLoaded, type: T.self)
            switch parsedResult {
            case .success(let parserResult):
                return parserResult
                
            case .failure(let parseError):
                throw parseError
            }
        case .failure( let error):
            throw error
        }
    }
}
