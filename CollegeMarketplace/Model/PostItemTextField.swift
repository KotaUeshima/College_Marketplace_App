//
//  PostItemTextField.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/10/23.
//

import Foundation
import UIKit

// custom text field for the Post Item page
class PostItemTextField: UITextField{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeTextField()
    }
    
    func customizeTextField(){
        // apply shadow
//        self.layer.shadowOpacity = 0.6
//        self.layer.shadowRadius = 3.0
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowColor = UIColor.gray.cgColor
        
        // corner radius
        self.layer.cornerRadius = 8
    }
}
