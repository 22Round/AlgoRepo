import Foundation

struct GitHubResponseModel: Codable {
    let name: String
    let description: String?
    let htmlUrl: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case description
            case htmlUrl = "html_url"
    }
}
