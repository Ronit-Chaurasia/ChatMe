//
//  LoginViewModel.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 04/08/24.
//

import Foundation

protocol SuccessAndFailureProtocol: AnyObject{
    func showSuccess(message: String)
    func showFailure(message: String)
}

protocol NavigationProtocol: AnyObject{
    func presentController()
}

class LoginViewModel{
    var statusDelegate: SuccessAndFailureProtocol?
    var navigationDelegate: NavigationProtocol?
    var showResendEmail: (()->Void)?
    
    private func goToApp(){
        navigationDelegate?.presentController()
    }
    
    func registerUser(email: String, password: String, confirmPassword: String){
        if password != confirmPassword{
            self.statusDelegate?.showFailure(message: "Passwords doesn't match")
            return
        }
        
        FirebaseUserListener.shared.registerUser(email, password) { [weak self] result in
            switch result{
                case .success(let message):
                    self?.statusDelegate?.showSuccess(message: message)
                    // Show Resend Email Button
                    DispatchQueue.main.async {
                        self?.showResendEmail?()
                    }
                
                case .failure(let error):
                    self?.statusDelegate?.showFailure(message: error.errorString)
            }
        }
    }
    
    func loginUser(email: String, password: String){
        FirebaseUserListener.shared.loginUserWith(email: email, password: password) { [weak self] result in
            
            switch result{
                case .success(let message):
                    self?.statusDelegate?.showSuccess(message: message)
                self?.goToApp()
                
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.statusDelegate?.showFailure(message: error.errorString)
                    
                    if case .verifyEmail(let emailVerified) = error, emailVerified == false {
                        print("Email verification failed.")
                        self?.showResendEmail?()
                    }
            }
        }
    }
    
    func resendVerificationEmail(){
        FirebaseUserListener.shared.resendVerificationEmail {[weak self] error in
            guard let self = self else{ return }
            
            if error != nil{
                self.statusDelegate?.showFailure(message: error!.localizedDescription)
            }else{
                self.statusDelegate?.showSuccess(message: "New verification email sent")
            }
        }
    }
    
    func resetPasswordForUser(email: String){
        
        FirebaseUserListener.shared.resetPasswordForUser(email: email) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result{
                
            case .success(let message):
                self.statusDelegate?.showSuccess(message: message)
                
            case . failure(let error):
                self.statusDelegate?.showFailure(message: error.localizedDescription)
            }
        }
    }
}
