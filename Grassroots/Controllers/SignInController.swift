//
//  SignInController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/10/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var addressField: UITextField!
  
  @IBAction func submitButton(sender: UIButton!) {
    
    self.performSegueWithIdentifier("addressSubmitted", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue,
                                sender: AnyObject?) {
    print("sup")
    if segue.identifier == "addressSubmitted" {
      print("seg")
      if let nextVC =
        segue.destinationViewController as? PoliticianTabController {
        if let address = addressField.text {
          print("yep")
          nextVC.model.address = address
        }
        else {
          print("unable to fetch text from text field")
        }
        
      }
      else {
        print("nerg")
      }
    }
    
  }
  
  func textFieldShouldReturn(addressField: UITextField!) -> Bool {
    
    addressField.resignFirstResponder()
    
    if addressField.text != nil {
      print("recovered text")
    }
    else {
      print("text not recovered")
    }
    
    return true
  }
  
  
  
}

