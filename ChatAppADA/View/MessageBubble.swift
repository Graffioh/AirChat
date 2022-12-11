//
//  MessageRowView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 09/12/22.
//

import SwiftUI

struct MessageBubble: View {
    
    @StateObject var chatVM: ChatViewModel
    var message: Message
    @State private var showTime = false
    var sender : String
    var chatId: String
    
    var body: some View {
        
        VStack(alignment: (sender != message.sender) ? .leading : .trailing) {
            HStack {
                Text(message.body)
                    .onLongPressGesture(minimumDuration: 1.5, perform: {chatVM.deleteMessage(chatId: chatId, msgId: message.id)})
                    .foregroundColor(.white)
                    .padding()
                    .background((sender != message.sender) ? Color.secondary : .blue)
                    .cornerRadius(20)
            }
            .frame(maxWidth: 450, alignment: (sender != message.sender) ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            
        }
      .frame(maxWidth: .infinity, alignment: (sender == message.sender) ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
       
        
    }
}


struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(chatVM: ChatViewModel(), message: Message(id: "12345", body: "First message", received: true, timestamp: Date(), sender : "sss", receiver : "sss"), sender : "SSS", chatId: "ciao")
    }
}
