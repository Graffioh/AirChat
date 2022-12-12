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

//Testing

struct ChatTest : Codable, Identifiable{
    var id : String
    var users : [User]
    var content : [Message]
}

class ChatViewModel : ObservableObject {
    @Published private(set) var chats : [ChatTest] = []
    @Published private(set) var chatMessages : [Message] = []
    
    let db  = Firestore.firestore()
    
    init(){
        self.getChats()
    }
    
    func addChat(users : [User]){
        let id = UUID()
        do{
            let newChat = ChatTest(id: "\(id)", users: users, content: [])
            try db.collection("chats").document("\(id)").setData(from : newChat)
        } catch{
            print("error while adding")
        }
    }
    
    // WIP (Chats)
    func getChats(){
        // Snapshot listener to get realtime updates from firebase
        db.collection("chats").addSnapshotListener { query, err in
            guard let chats = query?.documents else {
                print(err!)
                return
            }
            
            // Getting chat infos from firebase to chat array (id, name)
            self.chats = chats.compactMap { document -> ChatTest? in
                do{
                    return try document.data(as : ChatTest.self)
                }catch{
                    print("error while downloading")
                    return nil
                }
            }
        }
    }
    
    func getChatMessages(chatId: String) {
        db.collection("chats").document(chatId).collection("messages").addSnapshotListener { query, err in
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
    
    func addChatMessages(text : String, chatId: String, sender : String, receiver : String){
        do{
            // Instantiation of a new message
            let newMess = Message(id: "\(UUID())", body: text, received: false, timestamp: Date(), sender : sender, receiver : receiver)
            // setData method to add the new message inside the document specified
            try db.collection("chats").document(chatId).collection("messages").document(newMess.id).setData(from : newMess)
        } catch{
            print("error while adding")
        }
    }
    
    func deleteAllChatMessages(chatId: String){
        
        // Delete all
        // The batch is used to perform up to 500 actions at once
        let deleteAllBatch: WriteBatch = self.db.batch()
        
        // First delete all messages
        db.collection("chats").document(chatId).collection("messages").getDocuments() { (docSnapshot, err) in
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
    
    func deleteItem(indexSet: IndexSet) {
        chats.remove(atOffsets: indexSet)
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
    
    func deleteMessage(chatId: String, msgId: String){
        db.collection("chats").document(chatId).collection("messages").document(msgId).delete() { err in
            if let err = err {
                print("error while deleting message: \(err)")
            } else {
                print("message delete success")
            }
        }
    }
    
    func deleteChat(chatId: String){
        db.collection("chats").document(chatId).delete() { err in
            if let err = err {
                print("error while deleting message: \(err)")
            } else {
                print("chat delete success")
            }
        }
    }
}


