//
//  PoliticianTabController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/26/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class PoliticianTabController: UITabBarController {
  
  let model = PoliticianDataModel()
  
  var address = ""
  
  override func viewDidAppear(animated: Bool) {
    print("A")
    if !appHasLaunchedBefore() {
      print("B")
      self.performSegueWithIdentifier("loginView", sender: self)
    }
  }
  
  
  //EFFECTS: determines if app has launched before
  //MODIFIES: NSUserDefaults
  private func appHasLaunchedBefore() -> Bool {
    print("C")
    let launchedBefore =
      NSUserDefaults.standardUserDefaults().boolForKey("launched")
    print("launched before: \(launchedBefore)")
    if launchedBefore {
      return true
    }
    else {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched")
      return false
    }
  }
  
  
}
