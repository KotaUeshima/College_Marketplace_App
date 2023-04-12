//
//  SignUpViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: CustomTextField!
    
    @IBOutlet weak var lastNameTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var signUpButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide error label
        errorLabel.alpha = 0
        // disable sign up button
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
        
        // assign delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        firstNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        lastNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
         
        errorLabel.alpha = 0
        errorLabel.text = ""
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) {
            (result, error) in
            // Check for errors
            if error != nil{
                self.errorLabel.alpha = 1
                self.errorLabel.text = error!.localizedDescription
            }
            else{
                // Success
                let userId = result?.user.uid
                let userCollectionReference = Firestore.firestore().collection("users")
                userCollectionReference.document(userId!).setData([
                    "id": userId!,
                    "firstName": firstName,
                    "lastName": lastName,
                ]) { (error) in
                    
                    if error != nil{
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "Could not be saved to database"
                    }
                    
                    goToHomeScreen()
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
    
    // Enable or Disable Submit Button
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableOrDisableButton()
    }
    
    func enableOrDisableButton(){
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty{
            signUpButton.isEnabled = true
            signUpButton.alpha = 1
        }
        else{
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        }
    }
    
}
