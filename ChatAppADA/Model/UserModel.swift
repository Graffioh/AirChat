
import Foundation

struct User : Codable, Identifiable {
    var id : String
    var fullName : String
    var picked : Bool
}

