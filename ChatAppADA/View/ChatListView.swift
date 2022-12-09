//
//  ChatLIstView.swift
//  chat-app-ada
//
//  Created by Umberto Breglia on 07/12/22.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    
    var body: some View {
        NavigationView {
            List{
                ForEach(chatVM.chats, id : \.id) { chat in
                    NavigationLink{
                        ChatView(chatId: chat.id).environmentObject(chatVM) // Passing the chat id to get the messages of that specific chat
                    } label: {
                        Text(chat.name)
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    chatVM.addNewChat()
                } label: {
                    Text("Add chat")
                }
            }
        }
    }
}


//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListView()
//            .environmentObject(ChatViewModel())
//    }
//}
