import SwiftUI

struct ContentView: View {    
    @StateObject var dbManager = DbManager()
    @StateObject var chatVM = ChatViewModel()
    @State private var searchInput = ""
    @State var showingModal = false

    @State var user : User = User(id: "F9E12B4B-E5E8-485F-B741-E9BBA32BC42B", fullName: "Umberto Breglia", picked: true)
    //@State var user : User = User(id: "7FD1A842-EA1D-4D9D-BCF2-5F19ADEA0E1C", fullName: "Alessandro Vinaccia", picked: true, imageURL : URL(string : "https://dl.airtable.com/.attachments/d8e8bbbd3ed9796344e4d08b9a23b3d3/7f9e4585/UmbertoBreglia.png")!)
    //@State var user : User = User(id: "91F938F0-89C7-47DF-A8F7-D12ED79C9BA2", fullName: "Giovanni Michele Napoli", picked: true, imageURL : URL(string : "https://dl.airtable.com/.attachments/d8e8bbbd3ed9796344e4d08b9a23b3d3/7f9e4585/UmbertoBreglia.png")!)
//    @State var user : User = User(id: "33361B3E-8914-433F-B1C7-F4A19D59EF98", fullName: "Danilo Cotarella", picked: true, imageURL : URL(string : "https://dl.airtable.com/.attachments/d8e8bbbd3ed9796344e4d08b9a23b3d3/7f9e4585/UmbertoBreglia.png")!)

   
    // Filtered people based on search input
    var filteredPeople : [User] {
        if searchInput == "" { return dbManager.users}
        return dbManager.users.filter {
            $0.fullName.lowercased().contains(searchInput.lowercased())
        }
    }
    
    var body: some View {
        // Filter chats based on the user
        let filteredChats : [ChatTest] = chatVM.chats.filter { chat in
            return chat.users.contains(where: {$0.id == user.id})
        }
        
        NavigationStack {
            List {
                ForEach(filteredChats, id : \.id) { chat in
                    let receiver = chat.users.first(where : { $0.id != self.user.id })!
                    NavigationLink{
                        ChatView(chatVM: ChatViewModel(), sender: self.user.id, receiver: receiver, chatId: chat.id).environmentObject(chatVM)
                    } label: {
                        SingleUserRow(user: receiver)
                    }
                }.onDelete { indexSet in // Delete chat
                        indexSet.forEach { (i) in
                            chatVM.deleteAllChatMessages(chatId: chatVM.chats[i].id) // This is needed for firebase, because otherwise the subcollection will not be deleted
                            chatVM.deleteChat(chatId: chatVM.chats[i].id)
                        }
                    }
            }
//            .searchable(text: $searchInput)
            .navigationTitle("Air Chat")
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
                    NavigationStack { //file to split up the view
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
                        }.searchable(text: $searchInput)
                        .listStyle(.plain)
                        .navigationTitle("Contacts")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
