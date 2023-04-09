//
//  SignUpViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: CustomTextField!
    
    @IBOutlet weak var lastNameTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var signUpButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        firstNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        lastNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
    }
    
    func validateFields() -> String? {
        
        // Check all fields are not empty
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Some of the fields were left blank."
        }
        
        return nil
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error!
        }
        else{
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
        }
        
        // Transition to home screen
        func goToHomeScreen(){
            let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBar")
            
            view.window?.rootViewController = tabBar
            view?.window?.makeKeyAndVisible()
        }
    }
    
}
