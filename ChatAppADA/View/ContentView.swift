import SwiftUI

struct ContentView: View {    
    @StateObject var dbManager = DbManager()
    @StateObject var chatVM = ChatViewModel()
    @State private var searchInput = ""
    @State var showingModal = false
    
    //@State var user : User = User(id: "E066F003-2513-4032-9856-451C597F871B", fullName: "Umberto Breglia", picked: true)
    //@State var user : User = User(id: "61BB0FD5-555A-4198-855E-EE8D336693FA", fullName: "Alessandro Vinaccia", picked: true)
    //@State var user : User = User(id: "D987DF1A-BBE1-4738-BC32-2EFC239D60AF", fullName: "Giovanni Michele Napoli", picked: true)
    //@State var user : User = User(id: "27F77A76-3153-441A-A254-4713F132AD81", fullName: "Danilo Cotarella", picked: true)
    
    @State var user: User = User(id: "0", fullName: "0", picked: true)
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @AppStorage("userSelected") var userSelectedData: Data = Data()
    
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
                        chatVM.deleteAllChatMessages(chatId: filteredChats[i].id) // This is needed for firebase, because otherwise the subcollection will not be deleted
                        chatVM.deleteChat(chatId: filteredChats[i].id)
                    }
                }
            }.onAppear{ // On appear load user selected (from app storage)
                guard let userOut = try? JSONDecoder().decode(User.self, from: userSelectedData) else {return}
                user = userOut
            }
            .navigationTitle("AirChat")
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
                UserList(showingModal: $showingModal)
                
            }
        }
        .fullScreenCover(isPresented:  $shouldShowOnboarding,content: { OnboardingView(shouldShowOnboarding: $shouldShowOnboarding, userSelected: $user, userSelectedData: $userSelectedData).environmentObject(dbManager)})
    }
}
