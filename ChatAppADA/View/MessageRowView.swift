//
//  MessageRowView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 09/12/22.
//

import SwiftUI

struct MessageRowView: View {
    
    var message: Message
    @State private var showTime = false
    var sender : String
    
    var body: some View {
        
        VStack(alignment: (sender != message.sender) ? .leading : .trailing) {
            HStack {
                Text(message.body)
                    .foregroundColor(.white)
                    .padding()
                    .background((sender != message.sender) ? Color.secondary : .blue)
                    .cornerRadius(20)
            }
            .frame(maxWidth: 300, alignment: (sender != message.sender) ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding((sender != message.sender) ? .leading : .trailing, 10)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: (sender == message.sender) ? .leading : .trailing)
//        .padding(message.received ? .leading : .trailing)
        
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(message: Message(id: "12345", body: "First message", received: false, timestamp: Date(), sender : "sss", receiver : "sss"), sender : "SSS")
    }
}
