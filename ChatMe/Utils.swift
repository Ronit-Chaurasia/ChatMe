//
//  Utils.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 05/07/24.
//

import Foundation

enum LoginMessages: Error {
    case loginSuccess
    case verifyEmail(emailVerified: Bool?)
    case networkError
    case userNotRegistered
    case invalidPassword
    case invalidUsername
    case genericError(String)
    
    var errorString: String {
        switch self {
            case .loginSuccess:
                return "Login Successful"
            case .verifyEmail:
                return "Please Verify Your Email"
            case .networkError:
                return "Something went wrong, please try again"
            case .userNotRegistered:
                return "Please create an account for login"
            case .invalidPassword:
                return "Invalid Password"
            case .invalidUsername:
                return "Invalid Email"
            case .genericError(let message):
                return message
        }
    }
}

