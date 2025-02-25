//
//  FirebaseCollectionReference.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 05/07/24.
//

import Firebase

// Collections created by me on firebase
enum Collections: String{
    case user
    case recent
}

func databaseReferenceWith(collectionName: Collections) -> CollectionReference{
    return Firestore.firestore().collection(collectionName.rawValue)
}
