//
//  ProductCollectionViewCell.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/6/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    func setup(with product: Product){
        productImage.image = product.image
        productName.text = product.name
        productPrice.text = product.price
    }
}
