//
//  ContentView.swift
//  chat-app-ada
//
//  Created by Alessandro i on 07/12/22.
//

import SwiftUI

struct ContentView: View {    
    @StateObject var dbManager = DbManager()
    @StateObject var chatVM = ChatViewModel()
    @State private var searchInput = ""
    @State var showingModal = false

    @State var user : User = User(id: "E850B250-D341-4ABF-8370-D33B480CE506", fullName: "Umberto Breglia", picked: true, imageURL : URL(string : "https://dl.airtable.com/.attachments/d8e8bbbd3ed9796344e4d08b9a23b3d3/7f9e4585/UmbertoBreglia.png")!)
   
    // Filter based on search input
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
                // This basically filter chats based on who is the user that is using the app, so everyone have "personal" chats.
                    if chat.users.first(where: {$0.id == user.id}) != nil{
                        let receiver = chat.users.first(where : { $0.id != self.user.id })!
                        NavigationLink{
                            ChatView(chatVM: ChatViewModel(), sender: self.user.id, receiver: receiver, chatId: chat.id).environmentObject(chatVM)
                        } label: {
                            SingleUserRow(user: receiver)
                        }
                    }
                }.onDelete { indexSet in // Delete chat
                        indexSet.forEach { (i) in
                            chatVM.deleteAllChatMessages(chatId: chatVM.chats[i].id) // This is needed for firebase, because otherwise the subcollection will not be deleted (its written in the documentation)
                            chatVM.deleteChat(chatId: chatVM.chats[i].id)
                        }
                    }
            }
//            .searchable(text: $searchInput)
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
                         // If a user is already picked for a chat, it wont be displayed anymore in the modal view.
                        if chatVM.chats.first(where: {$0.users.first(where: {$0.id == person.id}) != nil}) == nil {
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

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
