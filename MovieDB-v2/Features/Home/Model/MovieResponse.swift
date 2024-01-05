

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}
