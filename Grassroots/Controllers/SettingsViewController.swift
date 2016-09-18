//
//  SettingsViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/14/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBAction func attributionButton(sender: AnyObject) {
    
    let URL = "http://www.icons8.com"
    
    if (UIApplication.sharedApplication().canOpenURL(
      NSURL(string: URL)!)) {
      UIApplication.sharedApplication().openURL(NSURL(string: URL)!)
    }
  }
  
  
}
