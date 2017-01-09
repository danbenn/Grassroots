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
  @IBOutlet weak var hours: UILabel!
  @IBOutlet weak var notes: UILabel!
  @IBOutlet weak var cityAndState: UILabel!
  @IBOutlet weak var line1: UILabel!
  @IBOutlet weak var locationName: UILabel!
  
  @IBOutlet weak var directionsOutlet: UIButton!
  @IBAction func directions(_ sender: AnyObject) {
    model.requestDrivingDirections()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if let place = model.pollingPlace {
      let fullAddress = place.line1 + ", "
        + place.city + ", " + place.state + " " + place.zip
      
      
      locationName?.text = place.name
      line1?.text = place.line1
      cityAndState?.text = place.city + ", " + place.state
      hours?.text = place.pollingHours
      notes?.text = place.notes
      
      addPinAtAddress(fullAddress)
      
    }
    else {
      line1?.text = "unavailable"
      directionsOutlet.isHidden = true
    }
  }
  
  func addPinAtAddress(_ address: String) {
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
  func centerMapOnLocation(_ location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(
      location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    PollMap.setRegion(coordinateRegion, animated: true)
  }

}



