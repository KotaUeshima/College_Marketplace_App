//
//  PostItemViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var nameTextField: PostItemTextField!
    
    @IBOutlet weak var priceTextField: PostItemTextField!
    
    @IBOutlet weak var addressTextField: PostItemTextField!
    
    @IBOutlet weak var conditionTextField: PostItemTextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var submitButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var onComplete: (() -> Void)?
    
    let userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInitialImage()
        
        // hide error label
        errorLabel.alpha = 0
        errorLabel.text = ""
        
        // set textfield delegates
        nameTextField.delegate = self
        priceTextField.delegate = self
        addressTextField.delegate = self
        conditionTextField.delegate = self
        // disable button on load and change color
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func createInitialImage(){
        selectedImage.image = UIImage(systemName: "plus.circle")
        selectedImage.tintColor = .black
        selectedImage.layer.cornerRadius = 8
        selectedImage.layer.borderWidth = 0.1
        selectedImage.layer.borderColor = UIColor.systemPink.cgColor
        selectedImage.contentMode = .center
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // if user picks an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let originalImage = info[.originalImage] as! UIImage
        selectedImage.image = originalImage
        selectedImage.contentMode = .scaleAspectFill
        
        picker.dismiss(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: CustomButton) {
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let price = priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let condition = conditionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // upload photo
        
        let storageRef = Storage.storage().reference()
        
        let image = selectedImage.image?.jpegData(compressionQuality: 0.8)
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let itemCollection = Firestore.firestore().collection("items")
        
        // upload to firestore storage
        let uploadTask = fileRef.putData(image!, metadata: nil, completion: {(metadata, error) in
            
            if error == nil && metadata != nil{

            }
            else{
                print("Error uploading image")
            }
            
        })
        
        // add document with imageUrl
        itemCollection.addDocument(data: [
            "userId": self.userId!,
            "name": name,
            "price": price,
            "address": address,
            "condition": condition,
            "imageUrl": path
        ])
        
        onComplete?()
        navigationController?.popViewController(animated: true)
    }
    
    // Enable or Disable Submit Button
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableOrDisableButton()
    }
    
    func enableOrDisableButton(){
        if !nameTextField.text!.isEmpty && !priceTextField.text!.isEmpty && !addressTextField.text!.isEmpty && !conditionTextField.text!.isEmpty{
            submitButton.isEnabled = true
            submitButton.alpha = 1
        }
        else{
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        }
    }
}
