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
  
  @IBAction func submitButton(_ sender: UIButton!) {
    
    self.performSegue(withIdentifier: "addressSubmitted", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                                sender: Any?) {
    if segue.identifier == "addressSubmitted" {
      if let nextVC =
        segue.destination as? PoliticianTabController {
        if let address = addressField.text {
          
          UserDefaults.standard.set(address, forKey: "address")
          
        }
        else {
          print("unable to fetch text from text field")
        }
        
      }
      else {
      }
    }
    
  }
  
  func textFieldShouldReturn(_ addressField: UITextField!) -> Bool {
    
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

