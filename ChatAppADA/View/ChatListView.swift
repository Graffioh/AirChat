//
//  ChatLIstView.swift
//  chat-app-ada
//
//  Created by Umberto Breglia on 07/12/22.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var chatVM: ChatViewModel
    
    var body: some View {
        NavigationView {
            List{
                ForEach(chatVM.chats, id : \.id) { chat in
                    NavigationLink{
                        ChatView(chatVM: chatVM, chatId: chat.id)
                        // Passing the chat id to get the messages of that specific chat
                    } label: {
                        Text(chat.name)
                    }
                }
            }
        }
    }
}


struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView(chatVM: ChatViewModel())
            
    }
}
