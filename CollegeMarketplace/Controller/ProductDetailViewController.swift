//
//  ProductDetailViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/21/23.
//

import Foundation
import UIKit
import MapKit

class ProductDetailViewController: UIViewController{
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var selectedImage: UIImage!
    var name: String!
    var condition: String!
    var price: String!
    var address: String!
    var productUserId: String!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let selectedImage = selectedImage{
            productImage.image = selectedImage
            productImage.layer.cornerRadius = 8
        }
        
        applyLabel(productNameLabel, name, "")
        applyLabel(conditionLabel, condition, "Condition:")
        applyLabel(priceLabel, price, "$")
        applyLabel(addressLabel, address, "Address:")
        
        setUpMap()
    }
    
    func applyLabel(_ label: UILabel,_ text: String?, _ textBefore: String){
        if let text = text{
            label.text = "\(textBefore) \(text)"
        }
    }
    
    func setUpMap(){
        let geocoder = CLGeocoder()
        
        if let address = address{
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                } else if let placemarks = placemarks, let location = placemarks.first?.location {
    
                    let annotation = MKPointAnnotation()

                    annotation.title = "Product Location"
                    annotation.coordinate = location.coordinate

                    self.mapView.addAnnotation(annotation)
                    
                    self.centerMapOnLocation(location, mapView: self.mapView)
                }
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? ChatViewController{
            Task {
                do{
                    try await ChatService.sharedInstance.uploadMessages(otherUserId: productUserId)
                    chatVC.messagesCollectionView.reloadData()
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}


