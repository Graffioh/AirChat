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
    
    var chatId: String
    
    var body: some View {
        VStack(alignment: .center){
            // Messages
            ForEach(chatVM.chatMessages, id : \.id) { chatMessage in
                Text(chatMessage.body)
                    .onLongPressGesture(minimumDuration: 1.5, perform: {chatVM.deleteMessage(chatId: chatId, msgId: chatMessage.id)})
            }
            .padding()
            
            // Input text field
            HStack{
                TextField("test", text: $input)
                Button {
                    chatVM.addChatMessages(text: input, chatId: chatId)
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
