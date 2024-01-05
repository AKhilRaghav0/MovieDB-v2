
import Foundation

struct TVResponse: Codable {
    let results: [Tv]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}
