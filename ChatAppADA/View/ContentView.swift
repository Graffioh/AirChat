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
    //@State var user : User = User(id: "6B38B654-5FBF-4D02-8C3F-38606B4E9DC2", fullName: "Alessandro Vinaccia", picked: true)
    @State var user : User = User(id: "E850B250-D341-4ABF-8370-D33B480CE506", fullName: "Umberto Breglia", picked: true)
    @State private var searchInput = ""
    @State var showingModal = false
    
    
    var filteredPeople : [User] {
        if searchInput == "" { return dbManager.users}
        return dbManager.users.filter {
            $0.fullName.lowercased().contains(searchInput.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center){
                ForEach(chatVM.chats, id : \.id) { chat in
                    // This basically filter chats based on who is the user that is using the app, so everyone have "personal" chats.
                    if chat.users.first(where: {$0.id == user.id}) != nil{
                        let receiver: User = chat.users.first(where : { $0.id != self.user.id })!
                        NavigationLink{
                            ChatView(sender: self.user.id, receiver: receiver, chatId: chat.id).environmentObject(chatVM)
                        } label: {
                            SingleUserRow(name: receiver.fullName)
                        }
                    }
                }
            }.navigationTitle("ChatApp")
                .toolbar {
//                    ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading){
//                        Button {
//
//                        } label: {
//                            Text("Edit")
//                        }
//                    }
                    ToolbarItemGroup(placement : ToolbarItemPlacement.navigationBarTrailing){
                        Button {
                            self.showingModal = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }.sheet(isPresented: $showingModal) {
                    List(filteredPeople){ person in
                        if chatVM.chats.first(where: {$0.users.first(where : {$0.id == person.id}) != nil}) == nil{
                            if person.id != user.id{
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
