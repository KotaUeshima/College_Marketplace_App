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

class ProductService{
    
    private var userProducts: [Product]
    private var allProducts: [Product]
    
    static let sharedInstance = ProductService()
    
    init() {
        userProducts = []
        allProducts = []
    }
    
    func clearAllProducts(){
        userProducts = []
        allProducts = []
    }
    
    func numberOfUserProducts() -> Int{
        return userProducts.count
    }
    
    func userAt(index: Int) -> Product{
        return userProducts[index]
    }
    
    func getUserProducts(onSuccess: @escaping ([Product]) -> Void){
        userProducts = allProducts.filter { product in
            product.userId == UserService.sharedInstance.getUserId()
        }
        onSuccess(userProducts)
    }
    
    func numberOfProducts() -> Int{
        return allProducts.count
    }
    
    func at(index: Int) -> Product{
        return allProducts[index]
    }
    
    func insert(product: Product){
        allProducts.append(product)
    }
    
    func getAllProducts(onSuccess: @escaping ([Product]) -> Void){
        let itemsCollection = Firestore.firestore().collection("items")
        itemsCollection.getDocuments { (snapshot, error) in
            if let error = error {
                print("Couldn't retrieve all products from Firebase Firestore")
                print(error.localizedDescription)
            }
            else{
                // for concurrency
                let lock = NSLock()
                // loop through all the documents
                for document in snapshot!.documents {
                    // grab image
                    let imagePath = document.data()["imageUrl"] as! String
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(imagePath)
                    var image: UIImage?
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024, completion: {
                        (data, error) in
                        
                        if error == nil && data != nil{
                            image = UIImage(data: data!)!
                            // add all data to allProducts
                            let new = Product(name: document.data()["name"] as! String, price: document.data()["price"] as! String, condition: document.data()["condition"] as! String, address: document.data()["address"] as! String, image: image!, userId: document.data()["userId"] as! String)
                            lock.lock()
                            self.allProducts.append(new)
                            lock.unlock()
                        }
                        else{
                            print("Couldn't retrieve photo from Firebase Storage")
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }
        }
        onSuccess(self.allProducts)
    }
    
    func postItem(name: String, price: String, address: String, condition: String, image: UIImage) async throws{
        
        // Add Image 
        let storageRef = Storage.storage().reference()
        let jpegImage = image.jpegData(compressionQuality: 0.8)!
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(jpegImage, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                print("Error uploading image to Firebase")
                print(error!.localizedDescription)
            }
        })
        
        // Add Document to Firebase Firestore
        let itemCollection = Firestore.firestore().collection("items")
        let userId = UserService.sharedInstance.getUserId()
        itemCollection.addDocument(data: [
            "userId": userId,
            "name": name,
            "price": price,
            "address": address,
            "condition": condition,
            "imageUrl": path
        ])
        // Add Document locally to product service
        let addition = Product(name: name, price: price, condition: condition, address: address, image: image, userId: userId)
        insert(product: addition)
    }
    
    func search(search: String){
        
    }
}
