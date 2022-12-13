
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

    func pickUser(id : String){
        print(id)
        db.collection("users").document(id).setData([ "picked": true ], merge: true)
    }
    // (function for debugging)
    func resetPicks(){
        for user in self.users{
            db.collection("users").document(user.id).setData([ "picked": false ], merge: true)
        }
    }
    
}

    
    


