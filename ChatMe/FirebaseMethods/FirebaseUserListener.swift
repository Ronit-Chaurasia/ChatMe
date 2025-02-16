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
    
    static let shared = FirebaseUserListener()
    private init(){}
    
    // MARK: Register User
    func registerUser(_ email: String, _ password: String, completion: @escaping (Result<String, LoginMessages>) -> Void){
        
        // Create new user and add to Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error == nil{
                // Send Email Verification
                authResult?.user.sendEmailVerification(completion: { error in
                    if error == nil{
                        completion(.success(LoginMessages.genericError("Registration Successful. Please check your Email to verify").errorString))
                    }else{
                        completion(.failure(.genericError(error!.localizedDescription)))
                    }
                })
                
                // Create user and save on Firestore Database
                guard let userData = authResult else{
                    return
                }
                
                let user = User(id: userData.user.uid, username: email, email: email, status: "Success")
                self?.saveDataLocally(user)
                self?.saveUserToFirestore(user)
                
            }else{
                completion(.failure(.genericError(error!.localizedDescription)))
            }
        }
    }
    
    // MARK: Login user
    func loginUserWith(email: String, password: String, completion: @escaping (Result<String, LoginMessages>) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error == nil  {
                if authResult!.user.isEmailVerified{
                    self?.downloadUserFromFirestoreAndSaveLocally(authResult!.user.uid, email)
                    completion(.success(LoginMessages.loginSuccess.errorString))
                }else{
                    completion(.failure(.verifyEmail(emailVerified: false)))
                }
            } else{
                if let error = error as NSError?{
                    self?.handleLoginErrors(error: error, completion: completion)
                }
            }
        }
    }
    
    func resendVerificationEmail(completion: @escaping (Error?) -> Void){
        // reload the user from server
        Auth.auth().currentUser?.reload()
        Auth.auth().currentUser?.sendEmailVerification { error in
            completion(error)
        }
    }
    
    func resetPasswordForUser(email: String, completion: @escaping (Result<String, Error>) -> Void){
        
        Auth.auth().sendPasswordReset(withEmail: email){error in
            if error == nil{
                completion(.success("A password reset email has been sent to \(email). Please check your inbox."))
            }else{
                completion(.failure(error!))
            }
        }
    }
}

// MARK: Helper Methods
extension FirebaseUserListener{
    // Save User Locally:- So that user don't have to login again & again
    private func saveDataLocally(_ user: User){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "currentUser")
        }catch{
            print("error saving data locally")
        }
    }
    
    // Save User to Firestore
    private func saveUserToFirestore(_ user: User){
        
        // Add a new document in collection "user"
        do {
            try databaseReferenceWith(collectionName: .user).document(user.id).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    private func downloadUserFromFirestoreAndSaveLocally(_ id: String, _ email: String){
        databaseReferenceWith(collectionName: .user).document(id).getDocument { [weak self] (documentSnapShot, error) in
            
            guard let document = documentSnapShot else{
                print("No document found")
                return
            }
            
            do{
                let user = try document.data(as: User.self)
                self?.saveDataLocally(user)
            }catch{
                print("error parsing document")
            }
        }
        print("Document successfully written!")
    }
    
    private func handleLoginErrors(error: NSError, completion: @escaping (Result<String, LoginMessages>) -> Void){
        switch AuthErrorCode.Code(rawValue: error.code){
        case .userNotFound:
            completion(.failure(.userNotRegistered))
            print("User not found. Please check your email.")
        case .wrongPassword:
            completion(.failure(.invalidPassword))
            print("Incorrect password. Please try again.")
        case .invalidEmail:
            completion(.failure(.invalidUsername))
            print("Invalid email address.")
        default:
            completion(.failure(.genericError(error.localizedDescription)))
        }
    }
}
