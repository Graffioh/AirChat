
import Foundation

struct User : Codable, Identifiable, Hashable {
    var id : String
    var fullName : String
    var picked : Bool
}

