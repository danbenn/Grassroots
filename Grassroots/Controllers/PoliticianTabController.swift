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
  
  override func viewDidAppear(_ animated: Bool) {
    print("A")
    if !appHasLaunchedBefore() {
      print("B")
      self.performSegue(withIdentifier: "loginView", sender: self)
    }
  }
  
  
  //EFFECTS: determines if app has launched before
  //MODIFIES: NSUserDefaults
  fileprivate func appHasLaunchedBefore() -> Bool {
    print("C")
    let launchedBefore =
      UserDefaults.standard.bool(forKey: "launched")
    print("launched before: \(launchedBefore)")
    if launchedBefore {
      return true
    }
    else {
      UserDefaults.standard.set(true, forKey: "launched")
      return false
    }
  }
  
  
}
