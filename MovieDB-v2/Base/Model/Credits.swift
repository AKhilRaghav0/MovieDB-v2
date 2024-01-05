
import Foundation

struct Credit: Codable, Hashable {
    let cast: [Cast]
}

struct Cast: Codable, Hashable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let profilePath: String?
    
    var profileURL: URL {
        return URL(string: "\(Constants.imgUrl)\(profilePath ?? "")")!
    }
}
