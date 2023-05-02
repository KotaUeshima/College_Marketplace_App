//
//  UserService.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/20/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService{
    
    private var currentUser: User?
    
    static let sharedInstance = UserService()
    
    init() {
        currentUser = nil
    }
    
    func getUserId() -> String{
        return currentUser!.userId
    }
    
    func getFullName() -> String{
        return "\(currentUser!.firstName) \(currentUser!.lastName)"
    }
    
    func login(email: String, password: String) async throws {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let userId = authResult.user.uid
        
        do{
            let fullName = try await getFullNameFromDatabase(userId: userId)
            currentUser = User(firstName: fullName.0, lastName: fullName.1, userId: userId)
        }catch{
            print("Could not get User from database")
            print(error.localizedDescription)
        }
    }
    
    func createAccount(firstName: String, lastName: String, email: String, password: String) async throws{
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let userId = authResult.user.uid
        
        let userCollectionReference = Firestore.firestore().collection("users")
        
        do{
            try await userCollectionReference.document(userId).setData([
                    "id": userId,
                    "firstName": firstName,
                    "lastName": lastName,
            ])
            currentUser = User(firstName: firstName, lastName: lastName, userId: userId)
        }catch{
            print("Could not save user to database")
            print(error.localizedDescription)
        }

    }
    
    func getFullNameFromDatabase(userId: String) async throws -> (String, String){
        let userDocument = Firestore.firestore().collection("users").document(userId)
        
        let snapshot = try await userDocument.getDocument()
        // do i need to check if it exists if I am doing try await
        if let data = snapshot.data(){
            let firstName = data["firstName"] as! String
            let lastName = data["lastName"] as! String
            return (firstName, lastName)
        }
            
        return ("", "")
    }
    
    func logout() throws{
        currentUser = nil
        ProductService.sharedInstance.clearAllProducts()
        try Auth.auth().signOut()
    }
}

