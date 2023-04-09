//
//  ProductsModel.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/6/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

class ProductsModel{
    
    var products: [Product]
    let itemsCollection = Firestore.firestore().collection("items")
    
    static let sharedInstance = ProductsModel()
    
    // function to get products for the current user
    func getMyProducts(onSuccess: @escaping ([Product]) -> Void){
        
        let userId = Auth.auth().currentUser?.uid
        
        // create query for user's items
        let query = itemsCollection.whereField("userId", isEqualTo: userId!)
        
        // sample photo for now
        let image = UIImage(named: "CoverPhoto")!

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    let new = Product(name: document.data()["name"] as! String, price: document.data()["price"] as! String, condition: document.data()["condition"] as! String, image: image)
                    self.products.append(new)
                }
                onSuccess(self.products)
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
