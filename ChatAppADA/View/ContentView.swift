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
    @State var showingModal = false
    @State var user : User = User(id: "E850B250-D341-4ABF-8370-D33B480CE506", fullName: "Umberto Breglia", picked: true)
    
    var filteredPeople : [User] {
        if searchInput == "" { return dbManager.users}
        return dbManager.users.filter {
            $0.fullName.lowercased().contains(searchInput.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(chatVM.chats, id : \.id) { chat in
                    if chat.users.first(where: {$0.id == user.id}) != nil{
                        let receiver = chat.users.first(where : { $0.id != self.user.id })!
                        NavigationLink{
                            ChatView(chatVM: ChatViewModel(), sender: self.user.id, receiver: receiver, chatId: chat.id).environmentObject(chatVM)
                        } label: {
                            SingleUserRow(name: receiver.fullName)
                        }
                    }
                }
            }
            .searchable(text: $searchInput)
            .navigationTitle("ChatApp")
                .listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading){
                        Button {
                            
                        } label: {
                            EditButton()
                        }
                        
                    }
                    ToolbarItemGroup(placement : ToolbarItemPlacement.navigationBarTrailing){
                        Button {
                            self.showingModal = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }.sheet(isPresented: $showingModal) {
                    NavigationStack {
                        List(filteredPeople){ person in
                            if person.id != user.id {
                                Button {
                                    print(person.id)
                                    chatVM.addChat(users: [user, person])
                                    self.showingModal = false
                                } label: {
                                    SingleUserRow(name: person.fullName)
                                }
                            }
                                
                            }
                        .searchable(text: $searchInput)
                    .listStyle(.plain)
                    .navigationTitle("Contacts")
                    .navigationBarTitleDisplayMode(.inline)
                    }
                   
                }
                
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
