//
//  MessageView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 08/12/22.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var dbManager = DbManager()
    @EnvironmentObject var chatVM: ChatViewModel
    @State var input = ""
    var user: User
    
    var body: some View {
        VStack {
//            Button {
//                dbManager.resetPicks()
//            } label: {
//                Text("Reset")
//            }


            ScrollView(showsIndicators: false) {
                ForEach(dbManager.messages, id : \.id) { message in
                    MessageRowView(message: message)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Reset", action: prova)
                        
                        Button {
                           prova()
                        } label: {
                            
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete all messages")
                            }
                        }

                    }                                                          label: {
                        Label("Add Item", systemImage: "ellipsis.circle")
                    }
                }
            })
            .padding(.horizontal)
            
            //TextfieldRowView() manca il file su github
        }
        .navigationTitle(user.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func prova() {
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MessageView( user: User(id: "2231", fullName: "Gianmchele", picked: true))
        }
    }
}
