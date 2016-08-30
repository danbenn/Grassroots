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

class PollingAddressViewController: UIViewController {
    
    @IBOutlet weak var PollMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let pollingInfo: JSON! = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        let pollingAddress = "6578 Brookhills Ct SE"
        addressLabel?.text = pollingAddress
        
        //center polling map here
        
        
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "SendAddressSegue" {
//            if let destination = segue.destinationViewController as? HomeViewController {
//                if TextField.text != nil {
//                    destination.pollingAddress = TextField.text!
//                }
//                else {print("error: cannot retrieve TextField text")}
//                
//                print(destination.pollingAddress)
//        
//                
//            }
//        }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}



