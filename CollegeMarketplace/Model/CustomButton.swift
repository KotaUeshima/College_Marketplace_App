//
//  CustomButton.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/7/23.
//

import Foundation
import UIKit

class CustomButton: UIButton{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeButton()
    }
    
    func customizeButton(){
        self.layer.cornerRadius = 20
    }
}
