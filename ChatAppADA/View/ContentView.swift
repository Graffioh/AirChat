//
//  ContentView.swift
//  chat-app-ada
//
//  Created by Alessandro Vinaccia on 07/12/22.
//

import SwiftUI

struct ContentView: View {    
    @StateObject var dbManager = DbManager()
    @StateObject var chatVM = ChatViewModel()
    @State private var searchInput = ""
    
    
    var filteredPeople : [User] {
        if searchInput == "" { return dbManager.users}
        return dbManager.users.filter {
            $0.fullName.lowercased().contains(searchInput.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center){
                
                List(filteredPeople){ person in
                    if !person.picked{
                        NavigationLink(destination: MessageView()) {
                            ListRowView(name: person.fullName)
                        }
                    }
                }.searchable(text: $searchInput)
                    .listStyle(.plain)
                
                
                NavigationLink(destination: ChatListView().environmentObject(chatVM)) {
                    Text("Chat list")
                }
                

            }.navigationTitle("ChatApp")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
