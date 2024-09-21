import Foundation

protocol RequestProviderProtocol {
  var urlRequest: URLRequest? { get }
}

class GitHubAPIRequestProvider: RequestProviderProtocol {
    
    private let serverUrl: String
    private let method: String
    init(service: EndPoint, method: HttpMethod) {
        serverUrl = service.description
        self.method = method.description
    }
    
    var urlRequest: URLRequest? {
        guard let url: URL = .init(string: serverUrl) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.httpMethod = method
        return request
    }
}

extension GitHubAPIRequestProvider {
    enum EndPoint {
        case repos(String)
        
        var description: String {
            switch self {
            case .repos(let path): return "\(Constants.baseURL)orgs/\(path)/repos"
            }
        }
    }
    
    enum HttpMethod {
        case post, get
        var description: String {
            switch self {
            case .post: return "POST"
            default: return "GET"
            }
        }
    }
}
