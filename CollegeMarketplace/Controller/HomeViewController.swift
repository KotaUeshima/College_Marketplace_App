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
        
        numberOfItemsLabel.text = "\(product.numberOfProducts()) items"
        // erase outline for search bar
        searchBar.backgroundImage = UIImage()
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
