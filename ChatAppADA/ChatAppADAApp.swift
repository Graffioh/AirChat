//
//  chat_app_adaApp.swift
//  chat-app-ada
//
//  Created by Alessandro Vinaccia on 07/12/22.
//

import SwiftUI
import Firebase

@main
struct chat_app_adaApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
