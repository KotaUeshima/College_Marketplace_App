//
//  ProfileViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let userId = Auth.auth().currentUser?.uid
    
    let shared = ProductsModel.sharedInstance
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addPostButton: CustomButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func signOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            shared.clearProducts()
            goToLoginScreen()
        }
        catch{
            // show error, maybe show an alert
            print("Could not sign out")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get first name and last name to display on profile
        if let userId = userId{
            let userDocument = Firestore.firestore().collection("users").document(userId)
            
            userDocument.getDocument(completion: {
                (snapshot, error) in
                if error != nil{
                    print(error!.localizedDescription)
                }
                else{
                    if let data = snapshot?.data(){
                        let firstName = data["firstName"] as! String
                        let lastName = data["lastName"] as! String
                        self.usernameLabel.text = "\(firstName) \(lastName)"
                    }
                }
            })
        }
        else{
            print("Could not get userId")
        }
        
        shared.getMyProducts(onSuccess: {
            products in
            self.collectionView.reloadData()
        })
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    // go to login screen
    func goToLoginScreen(){
        let loginNav = storyboard?.instantiateViewController(withIdentifier: "LoginNavigation")
        view.window?.rootViewController = loginNav
        view?.window?.makeKeyAndVisible()
    }
    
    // allow collection view to reload once data is added
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addProductVC = segue.destination as? PostItemViewController{
            addProductVC.onComplete = {
                self.shared.getMyProducts(onSuccess: {
                    products in
                    self.collectionView.reloadData()
                })
            }
        }
    }
}

// code for UICollectionView not Controller
extension ProfileViewController:
    UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return how many total items
        return shared.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.setup(with: shared.products[indexPath.row])
        
        return cell
    }
}

// Constraints for size of each cell
extension ProfileViewController:
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
}
