//
//  PostItemViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostItemViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var conditionTextField: UITextField!
    
    var onComplete: (() -> Void)?
    
    let userId = Auth.auth().currentUser?.uid
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let price = priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let condition = conditionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let itemCollection = Firestore.firestore().collection("items")
        
        itemCollection.addDocument(data: [
            "userId": userId!,
            "name": name,
            "price": price,
            "address": address,
            "condition": condition,
        ])
        
        onComplete?()
        navigationController?.popViewController(animated: true)
    }
    
}
