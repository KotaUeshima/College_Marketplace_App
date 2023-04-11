//
//  ProductsModel.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/6/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ProductsModel{
    
    var products: [Product]
    let itemsCollection = Firestore.firestore().collection("items")
    
    static let sharedInstance = ProductsModel()
    
    // function to get products for the current user
    func getMyProducts(onSuccess: @escaping ([Product]) -> Void){
        
        clearProducts()
        
        let userId = Auth.auth().currentUser?.uid
        
        // query to make collection of user's items
        let query = itemsCollection.whereField("userId", isEqualTo: userId!)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    
                    let imagePath = document.data()["imageUrl"] as! String
                    
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(imagePath)
                    
                    // use a system image, so won't crash even with no image
                    var image = UIImage(systemName: "camera")!
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024, completion: {
                        (data, error) in
                        
                        if error == nil && data != nil{
                            // create product if photo is succesfully retrieved
                            image = UIImage(data: data!)!
                            let new = Product(name: document.data()["name"] as! String, price: document.data()["price"] as! String, condition: document.data()["condition"] as! String, image: image)
                            self.products.append(new)
                            onSuccess(self.products)
                        }
                        else{
                            print("Couldn't retrieve photo from Firebase Storage")
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }
        }
    }

    func clearProducts(){
        products.removeAll()
    }
    
    init() {
        products = []
    }
}
