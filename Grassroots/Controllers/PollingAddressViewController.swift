//
//  ViewController.swift
//  sandbox
//
//  Created by Daniel Bennett on 6/16/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation

class PollingAddressViewController: UIViewController {
  
  @IBOutlet weak var PollMap: MKMapView!
  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var address: UILabel!
  
  @IBOutlet weak var directionsOutlet: UIButton!
  @IBAction func directions(sender: AnyObject) {
    model.requestDrivingDirections()
  }
  
  
  var model = PoliticianDataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tbc = self.tabBarController as! PoliticianTabController
    model = tbc.model
    
    if let place = tbc.model.pollingPlace {
      let fullAddress = place.line1 + ", "
        + place.city + ", " + place.state + " " + place.zip
      
      
      locationName?.text = place.name
      address?.text = fullAddress
      
      addPinAtAddress(fullAddress)
      
    }
    else {
      address?.text = "unavailable"
      directionsOutlet.hidden = true
    }
    
    
    
    
    
    
    
    
  }
  
  func addPinAtAddress(address: String) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler:
      {(placemarks, error) -> Void in
        if((error) != nil){
          print("Error", error)
        }
        if let placemark = placemarks?.first {
          let location = placemark.location!
          self.centerMapOnLocation(location)
          
          self.PollMap.addAnnotation(MKPlacemark(placemark: placemark))
        }
    })
  }
  
  
  let regionRadius: CLLocationDistance = 500
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(
      location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    PollMap.setRegion(coordinateRegion, animated: true)
  }
  
  
}



