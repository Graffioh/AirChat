
import SwiftUI

struct ChatView: View {
    @StateObject var chatVM: ChatViewModel
    @State var input = ""
    var sender : String
    var receiver : User
    
    var chatId: String
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Messages shown in a bubble.
                ForEach(chatVM.chatMessages, id : \.id) { chatMessage in
                    MessageBubble(chatVM: ChatViewModel(), message: chatMessage, sender : sender, chatId: chatId)
                }
                .padding()
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu { // Context menu
                        Button {
                            chatVM.deleteAllChatMessages(chatId: chatId)
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete all messages")
                            }
                        }
                    }
                label: {
                    Label("Add Item", systemImage: "ellipsis.circle")
                    }
                }
            })
            .padding(.horizontal)
            
            
            HStack{
                TextfieldRowView(input: $input)
                Button {
                    chatVM.addChatMessages(text: input, chatId: chatId, sender : sender, receiver : receiver.id)
                    input = ""
                } label: {
                    Image(systemName: "arrow.up").bold()
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.blue)
                        .cornerRadius(50)
                }
            }
            .padding(.trailing)
            .padding(.vertical)
        }.onAppear{
            // On appear get specific chat messages
            chatVM.getChatMessages(chatId: chatId)
            print("chat id: \(chatId)")
        }
        .navigationTitle(receiver.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}



