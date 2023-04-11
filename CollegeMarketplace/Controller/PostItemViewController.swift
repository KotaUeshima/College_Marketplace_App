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

class PostItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var nameTextField: PostItemTextField!
    
    @IBOutlet weak var priceTextField: PostItemTextField!
    
    @IBOutlet weak var addressTextField: PostItemTextField!
    
    @IBOutlet weak var conditionTextField: PostItemTextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    var onComplete: (() -> Void)?
    
    let userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInitialImage()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func createInitialImage(){
        selectedImage.image = UIImage(systemName: "plus.circle")
        selectedImage.tintColor = .black
        selectedImage.layer.cornerRadius = 8
        selectedImage.contentMode = .center
        selectedImage.layer.borderWidth = 1
        selectedImage.layer.borderColor = UIColor.black.cgColor
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
    
}
