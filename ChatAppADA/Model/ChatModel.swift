//
//  ChatMessageModel.swift
//  chat-app-ada
//
//  Created by Umberto Breglia on 08/12/22.
//

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
}
