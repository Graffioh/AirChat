
import Foundation

struct Chat: Codable, Identifiable {
    var id: String
    var name: String
}

struct Message: Codable, Identifiable {
    var id : String
    var body : String
    var received : Bool
    var timestamp : Date
    var sender : String
    var receiver : String
}
