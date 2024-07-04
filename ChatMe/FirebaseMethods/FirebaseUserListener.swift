//
//  FirebaseUserListener.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 05/07/24.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseUserListener{
    
    let shared = FirebaseUserListener()
    private init(){}

    // MARK: Register User
    func registerUser(_ email: String, _ password: String, completion: @escaping (String) -> Void){
        
        // Create new user and add to Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            if error == nil{
                // Send Email Verification
                authResult?.user.sendEmailVerification(completion: { error in
                    if error == nil{
                        completion("Email verification sent")
                    }
                })
                
                // Create user and save on Firestore Database
                guard let userData = authResult else{
                    return
                }
                
                let user = User(id: userData.user.uid, username: email, email: email, status: "Success")
                self?.saveDataLocally(user)
                self?.saveUserToFirestore(user )
                
            }else{
                completion(error!.localizedDescription)
            }
        }
    }
    
    // Save User Locally
    private func saveDataLocally(_ user: User){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "User")
        }catch{
            print("error saving data locally")
        }
    }
    
    // Save user to firestore
    private func saveUserToFirestore(_ user: User){
        
        // Add a new document in collection "cities"
        do {
            try databaseReferenceWith(collectionName: .user).document(user.id).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
}
