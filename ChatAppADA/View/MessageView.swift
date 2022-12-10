//
//  MessageView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 08/12/22.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var dbManager = DbManager()
    @State var input = ""
    
    
    var body: some View {
        VStack {
            Button {
                dbManager.resetPicks()
            } label: {
                Text("Reset")
            }


            ScrollView {
                ForEach(dbManager.messages, id : \.id) { message in
//                    MessageRowView(message: message, sender : message.sender)
                }
            }
            .padding()
           
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
