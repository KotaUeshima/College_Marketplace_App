//
//  ViewController.swift
//  CollegeMarketplace
// 
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseAuth

// This is the LoginViewController not sure how to change name
class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideErrorLabel()
        disableLoginButton()
        
        // assign delegates for textfield
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // add left images for custom text fields
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
        
        // fetch all products
        ProductService.sharedInstance.getAllProducts(onSuccess: {
            allProducts in
            print("Loaded in all products")
        })
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        hideErrorLabel()
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // async/await
        Task {
            do {
                try await UserService.sharedInstance.login(email: email, password: password)
                DispatchQueue.main.async {
                    self.goToHomeScreen()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    // Function called everytime user types in one of the textfields
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableOrDisableButton()
    }
    
    func enableOrDisableButton(){
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty{
            enableLoginButton()
        }
        else{
            disableLoginButton()
        }
    }
    
    func enableLoginButton(){
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }
    
    func disableLoginButton(){
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
    
    func hideErrorLabel(){
        errorLabel.alpha = 0
        errorLabel.text = ""
    }
    
    // Transition to Home Screen
    func goToHomeScreen(){
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        view.window?.rootViewController = tabBar
        view?.window?.makeKeyAndVisible()
    }
}

