//
//  ChatView.swift
//  chat-app-ada
//
//  Created by Umberto Breglia on 08/12/22.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @State var input = ""
    var sender : String
    var receiver : String
    
    var chatId: String
    
    var body: some View {
        VStack(alignment: .center){
            // Messages
            ForEach(chatVM.chatMessages, id : \.id) { chatMessage in
                MessageRowView(message: chatMessage, sender : sender)
            }
            .padding()
            
            // Input text field
            HStack{
                TextField("test", text: $input)
                Button {
                    chatVM.addChatMessages(text: input, chatId: chatId, sender : sender, receiver : receiver)
                    input = ""
                } label: {
                    Image(systemName: "airplane")
                }
            }
            // Delete messages button
            Button {
                chatVM.deleteAllChatMessages(chatId: chatId)
            } label: {
                Text("Delete all chat messages")
                    .bold()
                    .foregroundColor(.red)
            }
            .padding()
        }.onAppear{
            chatVM.getChatMessages(chatId: chatId) // On appear get specific chat messages
            print("chat id: \(chatId)")
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chatId: String)
//            .environmentObject(DbManager())
//    }
//}
