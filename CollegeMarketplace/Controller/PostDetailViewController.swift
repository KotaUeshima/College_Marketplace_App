//
//  PostDetailViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/11/23.
//

import Foundation
import UIKit

class PostDetailViewController: UIViewController{
    
    var selectedImage: UIImage!
    var name: String!
    var condition: String!
    var price: String!
    var address: String!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad(){
        
        if let selectedImage = selectedImage{
            productImage.image = selectedImage
            productImage.layer.cornerRadius = 8
        }
        
        applyLabel(nameLabel, name)
        applyLabel(conditionLabel, condition)
        applyLabel(priceLabel, price)
        applyLabel(addressLabel, address)
    }
    
    func applyLabel(_ label: UILabel,_ text: String?){
        if let text = text{
            label.text = text
        }
    }
}
