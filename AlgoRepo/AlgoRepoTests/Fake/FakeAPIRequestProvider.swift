import Foundation
@testable import AlgoRepo

final class FakeAPIRequestProvider: RequestProviderProtocol {
    init() {}
    
    var urlRequest: URLRequest?
}
