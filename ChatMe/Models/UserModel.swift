//
//  UserModel.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 05/07/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


struct User: Codable{
    var id = ""
    var username: String
    var email: String
    var pushId: String = ""
    var avatarLink: String = ""
    var status: String
}
