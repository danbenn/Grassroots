//
//  ProfileViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 12/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  var name = String()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Profile"
    
    let profileImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "square_logo")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFill
      return imageView
    }()
    
    self.title = name

      
        
  }

}
