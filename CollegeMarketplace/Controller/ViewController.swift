//
//  ViewController.swift
//  CollegeMarketplace
// 
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
    }
    
    func validateFields() -> String? {
        
        // Check all fields are not empty
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Some of the fields were left blank."
        }
        
        return nil
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error!
        }
        else{
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
    }
    
    // Transition to home screen
    func goToHomeScreen(){
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        
        view.window?.rootViewController = tabBar
        view?.window?.makeKeyAndVisible()
    }
    
}

