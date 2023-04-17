//
//  HomeViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    let shared = ProductsModel.sharedInstance
    
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate for homeCollectionView
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.collectionViewLayout = UICollectionViewFlowLayout()

        // get all products
//        shared.getAllProducts(onSuccess: {
//            products in
//            self.homeCollectionView.reloadData()
//        })
        
        numberOfItemsLabel.text = "\(shared.allProducts.count) items"
        
        // set up for search bar UI
        searchBar.backgroundImage = UIImage()
    }

    // allow collection view to reload once data is added
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send information to postDetailVC
        if let postDetailVC = segue.destination as? PostDetailViewController{
            let selectedRow = homeCollectionView.indexPathsForSelectedItems!.first!.row
            let selectedProduct = shared.allProducts[selectedRow]
            postDetailVC.selectedImage = selectedProduct.image
            postDetailVC.name = selectedProduct.name
            postDetailVC.condition = selectedProduct.condition
            postDetailVC.price = selectedProduct.price
            postDetailVC.address = selectedProduct.address
        }
    }
    
}

// code for UICollectionView not Controller
extension HomeViewController:
    UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return how many total items
        return shared.allProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell

        cell.setup(with: shared.allProducts[indexPath.row])

        return cell
    }
}

// Constraints for size of each cell
extension HomeViewController:
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // width of current view controller
        // height of the image is restricted to 130
        let width = self.view.bounds.width
        return CGSize(width: (width / 2) - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
}
