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
        // corner radius
        self.layer.cornerRadius = 8
        
        // apply colored outline
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.systemPink.cgColor
    }
}
