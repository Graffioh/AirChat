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
    
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing) {
            HStack {
                Text(message.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(message.received ? Color.secondary : .blue)
                    .cornerRadius(20)
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(message.received ? .leading : .trailing, 10)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
//        .padding(message.received ? .leading : .trailing)
        
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(message: Message(id: "12345", body: "First message", received: true, timestamp: Date()))
    }
}
