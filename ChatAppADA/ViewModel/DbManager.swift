//
//  DbManager.swift
//  chat-app-ada
//
//  Created by Alessandro Vinaccia on 07/12/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class DbManager : ObservableObject {
    @Published private(set) var messages : [Message] = []
    @Published private(set) var users : [User] = []
    
    let db  = Firestore.firestore()
    
    init(){
        self.populate()
    }
    
    func populate() {
        db.collection("users").addSnapshotListener { query, err in
            guard let documents = query?.documents else {
                print(err!)
                return
            }
            
            self.users = documents.compactMap { document -> User? in
                do{
                    return try document.data(as : User.self)
                }catch{
                    print("error while downloading users")
                    return nil
                }
            }
            self.users.sort { $0.fullName < $1.fullName }
        }
    }

    func deleteAllMessages(){
        // Single delete
//        db.collection("messages").document("\(document_name)").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("All messages deleted")
//            }
//        }
        
        // Delete all
        let deleteAllBatch: WriteBatch = self.db.batch() // The batch is used to perform up to 500 actions at once
        
        db.collection("messages").getDocuments() { (docSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in docSnapshot!.documents {
                    deleteAllBatch.deleteDocument(document.reference)
                }
                
                deleteAllBatch.commit() { err in // First delete all messages and then commit the changes, like git!
                    if let err = err {
                        print("Error writing batch \(err)")
                    } else {
                        print("Batch write succeeded")
                    }
                }
            }
        }
    }
    
    func pickUser(id : String){
        print(id)
        db.collection("users").document(id).setData([ "picked": true ], merge: true)
    }
    //funzione per debug, ripristina la lista mettendo tutti gli user come NON selezionati
    func resetPicks(){
        for user in self.users{
            db.collection("users").document(user.id).setData([ "picked": false ], merge: true)
        }
    }
    
}

    
    


