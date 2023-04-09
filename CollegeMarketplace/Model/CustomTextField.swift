//
//  CustomTextField.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/7/23.
//

import Foundation
import UIKit

class CustomTextField: UITextField{
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeTextField()
    }
    
    func customizeTextField(){
        // remove border and background
        self.borderStyle = .none
        self.background = nil
        
        // add underline at the bottom
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    func addImage(image: UIImage){
        // add image
        self.leftViewMode = .always
        let leftView = UIImageView(frame: CGRect(x: 0, y: self.frame.height / 2 - 10, width: 25, height: 20))
        leftView.tintColor = .black
        leftView.image = image
        self.addSubview(leftView)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect{
        let bounds = CGRect(x: 35, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: 35, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: 35, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
}
