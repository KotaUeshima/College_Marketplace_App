//
//  ViewController.swift
//  CollegeMarketplace
// 
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide error label
        errorLabel.alpha = 0
        // disable login button
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        // assign delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        errorLabel.alpha = 0
        errorLabel.text = ""
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                self.errorLabel.alpha = 1
                self.errorLabel.text = error!.localizedDescription
            }
            else{
                self.goToHomeScreen()
            }
        }

    }
    
    // Enable or Disable Submit Button
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableOrDisableButton()
    }
    
    func enableOrDisableButton(){
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty{
            loginButton.isEnabled = true
            loginButton.alpha = 1
        }
        else{
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
    
    // Transition to home screen
    func goToHomeScreen(){
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        
        view.window?.rootViewController = tabBar
        view?.window?.makeKeyAndVisible()
    }
}

