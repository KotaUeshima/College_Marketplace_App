//
//  PostItemViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/5/23.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate  {
    
    @IBOutlet weak var nameTextField: PostItemTextField!
    
    @IBOutlet weak var priceTextField: PostItemTextField!
    
    @IBOutlet weak var addressTextField: PostItemTextField!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var conditionTextField: PostItemTextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var submitButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var onComplete: (() -> Void)?
    
    let userId = Auth.auth().currentUser?.uid
    
    var completer = MKLocalSearchCompleter()
    
    var searchResults = [MKLocalSearchCompletion]()
    
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
        
        // add tap gesture for UIImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
        
        // auto complete object
        completer.delegate = self
        
        // table view delegation
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        print("How many results is coming >>> \(completer.results.count)")
        searchTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error with auto completion")
        print(error)
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
        
        // changing query for completer
        if textField == addressTextField{
            if let text = addressTextField.text{
                completer.queryFragment = text
            }
        }
        
        if !textField.text!.isEmpty{
            textField.layer.borderWidth = 0.5
        }
        else{
            textField.layer.borderWidth = 0.1
        }
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

extension PostItemViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let currentSearch = searchResults[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = currentSearch.title
        cell.detailTextLabel?.text = currentSearch.subtitle
            
        return cell
    }
    
}

extension PostItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let result = searchResults[indexPath.row]
        
        // change text field cell to result and then reload tableview
        addressTextField.text = result.title
        searchResults = [MKLocalSearchCompletion]()
        searchTableView.reloadData()
        
    }
}
