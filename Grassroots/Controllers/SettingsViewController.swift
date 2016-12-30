//
//  SettingsViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/14/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  
  let changeAddressButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    button.setTitle("Change my address", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
    button.addTarget(nil, action: #selector(changeAddress), for: .touchUpInside)
    return button
  }()
  
  func changeAddress() {
    performSegue(withIdentifier: "changeAddress", sender: self)
  }
  
  func setupChangeAddressButton() {
    //need x, y, width, height constraints
    changeAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //changeAddressButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    changeAddressButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
    changeAddressButton.widthAnchor.constraint(equalTo:
      view.widthAnchor, constant: -24).isActive = true
  
    changeAddressButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(changeAddressButton)
    setupChangeAddressButton()
  }

  
  
}
