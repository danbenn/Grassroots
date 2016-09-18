//
//  SettingsViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/14/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBAction func attributionButton(_ sender: AnyObject) {
    
    let URL = "http://www.icons8.com"
    
    if (UIApplication.shared.canOpenURL(
      Foundation.URL(string: URL)!)) {
      UIApplication.shared.openURL(Foundation.URL(string: URL)!)
    }
  }
  
  
}
