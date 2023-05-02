//
//  HomeViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    let product = ProductService.sharedInstance
    
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate for homeCollectionView
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        // erase outline for search bar
        searchBar.backgroundImage = UIImage()
    }
    
    // reload data and number of items label each time view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeCollectionView.reloadData()
        numberOfItemsLabel.text = "\(product.numberOfProducts()) items"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send information to postDetailVC
        if let postDetailVC = segue.destination as? ProductDetailViewController{
            let selectedRow = homeCollectionView.indexPathsForSelectedItems!.first!.row
            let selectedProduct = product.at(index: selectedRow)
            postDetailVC.selectedImage = selectedProduct.image
            postDetailVC.name = selectedProduct.name
            postDetailVC.condition = selectedProduct.condition
            postDetailVC.price = selectedProduct.price
            postDetailVC.address = selectedProduct.address
            postDetailVC.productUserId = selectedProduct.userId
        }
    }
}

extension HomeViewController:
    UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.numberOfProducts()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.setup(with: product.at(index: indexPath.row))
        return cell
    }
}

// constraints for each cell
extension HomeViewController:
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        return CGSize(width: (width / 2) - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
