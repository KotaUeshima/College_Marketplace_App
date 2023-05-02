//
//  ProfileViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/5/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user = UserService.sharedInstance
    
    let product = ProductService.sharedInstance
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addPostButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func signOutButton(_ sender: Any) {
        do{
            try user.logout()
            goToLoginScreen()
        }
        catch{
            print("Could not sign out")
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make button round
        addPostButton.layer.cornerRadius = addPostButton.frame.height / 2
        self.usernameLabel.text = user.getFullName()
        
        product.getUserProducts(onSuccess: {
            products in
            self.collectionView.reloadData()
        })
        
        // set delegates for collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // reload data once a product is added
        if let addProductVC = segue.destination as? PostItemViewController{
            addProductVC.onComplete = {
                self.product.getUserProducts(onSuccess: {
                    products in
                    self.collectionView.reloadData()
                })
            }
        }
        // send information to postDetailVC
        if let postDetailVC = segue.destination as? PostDetailViewController{
            let selectedRow = collectionView.indexPathsForSelectedItems!.first!.row
            let selectedProduct = product.userAt(index: selectedRow)
            postDetailVC.selectedImage = selectedProduct.image
            postDetailVC.name = selectedProduct.name
            postDetailVC.condition = selectedProduct.condition
            postDetailVC.price = selectedProduct.price
            postDetailVC.address = selectedProduct.address
        }
    }
    
    func goToLoginScreen(){
        let loginNav = storyboard?.instantiateViewController(withIdentifier: "LoginNavigation")
        view.window?.rootViewController = loginNav
        view?.window?.makeKeyAndVisible()
    }
}

extension ProfileViewController:
    UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.numberOfUserProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.setup(with: product.userAt(index: indexPath.row))
        return cell
    }
}

// constraints for each cell
extension ProfileViewController:
    UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        return CGSize(width: (width / 2) - 40, height: 150)
    }
}
