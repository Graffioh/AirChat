//
//  UserList.swift
//  ChatAppADA
//
//  Created by Giovanni Michele on 15/12/22.
//

import SwiftUI


struct UserList: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var dbManager = UserViewModel()
    @Binding var showingModal: Bool
    @State var searchable = ""
    @StateObject var chatVM = ChatViewModel()
    var user : User
    
    var filteredPeople : [User] {
        if searchable == "" { return
            dbManager.users}
        return dbManager.users.filter {
            $0.fullName.lowercased().contains(searchable.lowercased())
        }
    }
    
    var body: some View {
        
        let filteredChats : [ChatTest] = chatVM.chats.filter { chat in
            return chat.users.contains(where: {$0.id == user.id})
        }
        
        NavigationView {
            //file to split up the view
            List(filteredPeople){ person in
                // (for debug)
                //if chatVM.chats.contains(where: {$0.users.first(where: {$0.id == person.id}) != nil}) {
                
                // You will not be displayed in the modal view.
                if person.id != user.id {
                    // If a user is already picked for a chat, it wont be displayed anymore in the modal view.
                    if !filteredChats.contains(where: {$0.users.contains(where: {$0.id == person.id})}){
                        Button {
                            print(person.id)
                            chatVM.addChat(users: [user, person])
                            self.showingModal = false
                        } label: {
                            SingleUserRow(user : person)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                       dismiss()
                    } label: {
                        Text("Fine").bold()
                    }
      
                }
            }
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchable)
        .listStyle(.plain)
        
    }
}


