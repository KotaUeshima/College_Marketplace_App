//
//  HomeCollectionViewCell.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/12/23.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    func setup(with product: Product){
        productImage.image = product.image
        productImage.layer.cornerRadius = 8
        productName.text = product.name
        productPrice.text = "$\(product.price)"
    }
    
}
