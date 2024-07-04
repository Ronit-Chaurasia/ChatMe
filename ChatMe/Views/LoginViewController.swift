//
//  ViewController.swift
//  ChatMe
//
//  Created by Ronit Chaurasia on 01/07/24.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    // MARK: IBOutlets
    
    // Labels
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // Views
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    
    // MARK: IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if verifyUserDetails(signupTapped ? "register" : "login"){
            print("have data for login/Register")
        }else{
            ProgressHUD.colorAnimation = UIColor.red
            ProgressHUD.colorHUD = UIColor.systemGray4
            ProgressHUD.failed("All fields are required")
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if verifyUserDetails("password"){
            print("have data for pasword reset")
        }else{
            ProgressHUD.colorAnimation = UIColor.red
            ProgressHUD.colorHUD = UIColor.systemGray4
            ProgressHUD.failed("Email is Required")
        }
    }
    
    @IBAction func resendEmailTapped(_ sender: Any) {
        if verifyUserDetails("password"){
            print("have data for pasword reset")
        }else{
            ProgressHUD.colorAnimation = UIColor.red
            ProgressHUD.colorHUD = UIColor.systemGray4
            ProgressHUD.failed("Email is Required")
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        if signupTapped == false{
            setRegisterUI()
            signupTapped.toggle()
        }else{
            initialConfiguration()
            signupTapped.toggle()
        }
    }
    
    // MARK: Stored properties
    var signupTapped = false
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        initialConfiguration()
        addTextfieldDelegates()
        addTapGesture()
    }
    
    // MARK: Configuration Methods
    private func initialConfiguration(){
        loginLabel.text = "Log In"
        welcomeBackLabel.isHidden = false
        resendEmailButton.isHidden = true
        welcomeBackLabel.text = "Welcome Back !"
        accountLabel.text = "Don't have an account?"
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signupButton.setTitle("Sign Up", for: .normal)
        
        // Animate Confirm password view
        confirmPasswordStackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.confirmPasswordStackView.isHidden = true
            self.forgotPasswordButton.isHidden = false
        })
    }
    
    private func setRegisterUI(){
        loginLabel.text = "Sign Up"
        accountLabel.text = "Already have an account?"
        signupButton.setTitle("Log In", for: .normal)
        welcomeBackLabel.text = "Welcome Onboard !"
        forgotPasswordButton.isHidden = true
    
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmPasswordStackView.isHidden = false
        }){ _ in
            self.confirmPasswordStackView.alpha = 1.0
        }
    }
}

//MARK: Textfield delegates
extension LoginViewController: UITextFieldDelegate{
 
    private func addTextfieldDelegates(){
        emailTextField.addTarget(self, action: #selector(textfieldDidChange(_ :)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textfieldDidChange(_ :)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textfieldDidChange(_ :)), for: .editingChanged)
    }
    
    @objc private func textfieldDidChange(_ textField: UITextField){
        updatePlaceholderLabels(textField)
    }
    
    private func updatePlaceholderLabels(_ textField: UITextField){
        switch textField{
            case emailTextField:
                emailLabel.text = textField.hasText ? "Email" : ""
            case passwordTextField:
                passwordLabel.text = textField.hasText ? "Password" : ""
            default:
                confirmPasswordLabel.text = textField.hasText ? "Confirm Password" : ""
        }
    }
}

// MARK: Keyboard Handling
extension LoginViewController{
    
    private func addTapGesture(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}

// MARK: Helper Methods
extension LoginViewController{
    private func verifyUserDetails(_ field: String) -> Bool{
        switch field{
        case "login":
            return emailTextField.hasText && passwordTextField.hasText
            
        case "register":
            return emailTextField.hasText && passwordTextField.hasText && confirmPasswordTextField.hasText
            
        default:
            return emailTextField.hasText
        }
    }
}
