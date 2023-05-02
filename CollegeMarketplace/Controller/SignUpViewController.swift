//
//  SignUpViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: CustomTextField!
    
    @IBOutlet weak var lastNameTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var signUpButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideErrorLabel()
        disableSignUpButton()
        
        // assign text field delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // add left images to text fields
        firstNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        lastNameTextField.addImage(image: UIImage(systemName: "person.fill")!)
        emailTextField.addImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.addImage(image: UIImage(systemName: "lock")!)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
         
        hideErrorLabel()
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Task{
            do{
                try await UserService.sharedInstance.createAccount(firstName: firstName, lastName: lastName, email: email, password: password)
                DispatchQueue.main.async{
                    self.goToHomeScreen()
                }
            }catch{
                DispatchQueue.main.async{
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
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty{
            enableSignUpButton()
        }
        else{
            disableSignUpButton()
        }
    }
    
    func disableSignUpButton(){
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
    }
    
    func enableSignUpButton(){
        signUpButton.isEnabled = true
        signUpButton.alpha = 1
    }
    
    func hideErrorLabel(){
        errorLabel.alpha = 0
        errorLabel.text = ""
    }
    
    func goToHomeScreen(){
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        
        view.window?.rootViewController = tabBar
        view?.window?.makeKeyAndVisible()
    }
    
}
