//
//  MessageView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 08/12/22.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @State var input = ""
    var sender : String
    var receiver : User
    
    var chatId: String
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Message list
                ForEach(chatVM.chatMessages, id : \.id) { chatMessage in
                    MessageBubble(message: chatMessage, sender : sender, chatId: chatId).environmentObject(chatVM)
                }
                .padding()
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            chatVM.deleteAllChatMessages(chatId: chatId)
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete all messages")
                            }
                        }
                    } label: {
                        Label("Add Item", systemImage: "ellipsis.circle")
                    }
                }
            })
            .padding(.horizontal)
            
            //TextfieldRowView() manca il file su github
            HStack{
                TextField("test", text: $input)
                Button {
                    chatVM.addChatMessages(text: input, chatId: chatId, sender : sender, receiver : receiver.id)
                    input = ""
                } label: {
                    Image(systemName: "airplane")
                }
            }
        }.onAppear{
            chatVM.getChatMessages(chatId: chatId) // On appear get specific chat messages
            print("chat id: \(chatId)")
        }
        .navigationTitle(receiver.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
