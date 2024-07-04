//
//  FirebaseCollectionReference.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 05/07/24.
//

import FirebaseFirestore

enum Collections: String{
    case user
    case recent
}

func databaseReferenceWith(collectionName: Collections) -> CollectionReference{
    return Firestore.firestore().collection(collectionName.rawValue)
}
