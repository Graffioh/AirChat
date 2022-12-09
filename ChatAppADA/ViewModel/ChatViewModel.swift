//
//  ChatMessageViewModel.swift
//  chat-app-ada
//
//  Created by Umberto Breglia on 08/12/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewModel : ObservableObject {
    @Published private(set) var chats : [Chat] = []
    @Published private(set) var chatMessages : [Message] = []
    
    let db  = Firestore.firestore()
    
    init(){
        self.getChats()
    }
    
    // WIP (Chats)
    func getChats(){
        // Snapshot listener to get realtime updates from firebase
        db.collection("chatsTry1").addSnapshotListener { query, err in
            guard let chats = query?.documents else {
                print(err!)
                return
            }
            
            // Getting chat infos from firebase to chat array (id, name)
            self.chats = chats.compactMap { document -> Chat? in
                do{
                    return try document.data(as : Chat.self)
                }catch{
                    print("error while downloading")
                    return nil
                }
            }
        }
    }
    
    func getChatMessages(chatId: String) {
        db.collection("chatsTry1").document(chatId).collection("messages").addSnapshotListener { query, err in
            guard let documents = query?.documents else {
                print(err!)
                return
            }
            
            // Getting the messages infos from firebase to chatMessages array (id, body, received, timestamp)
            self.chatMessages = documents.compactMap { document -> Message? in
                do{
                    return try document.data(as : Message.self)
                }catch{
                    print("error while downloading")
                    return nil
                }
            }
            self.chatMessages.sort { $0.timestamp < $1.timestamp }
        }
    }
    
    func addChatMessages(text : String, chatId: String){
        do{
            // Instantiation of a new message
            let newMess = Message(id: "\(UUID())", body: text, received: false, timestamp: Date())
            // setData method to add the new message inside the document specified
            try db.collection("chatsTry1").document(chatId).collection("messages").document().setData(from : newMess)
        } catch{
            print("error while adding")
        }
    }
    
    func deleteAllChatMessages(chatId: String){
        
        // Delete all
        // The batch is used to perform up to 500 actions at once
        let deleteAllBatch: WriteBatch = self.db.batch()
        
        // First delete all messages
        db.collection("chatsTry1").document(chatId).collection("messages").getDocuments() { (docSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in docSnapshot!.documents {
                    deleteAllBatch.deleteDocument(document.reference)
                }
                
                // and then commit the changes, like git!
                deleteAllBatch.commit() { err in
                    if let err = err {
                        print("Error writing batch \(err)")
                    } else {
                        print("Batch write succeeded")
                    }
                }
            }
        }
    }
    
    // This will create a new chat and when a message is written inside create automatically the subcollection "messages" on firebase
    func addNewChat(){
        do{
            let newChat = Chat(id: "\(UUID())", name: "chat\(chats.count + 1)")
            try db.collection("chatsTry1").document(newChat.id).setData(from: newChat)
        } catch{
            print("error while adding")
        }
    }
}


