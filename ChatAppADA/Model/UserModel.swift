//
//  Model.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 07/12/22.
//

import Foundation

struct User : Codable, Identifiable {
    var id : String
    var fullName : String
    var picked : Bool
}

