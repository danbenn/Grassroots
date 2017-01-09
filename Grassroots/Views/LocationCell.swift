//
//  LocationCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/19/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
  
  var parentVC: HomeViewController!
  
  let viewConstants = ViewConstants()
  
  let tapRecognizer: UIButton = {
    let button = UIButton()
    button.tintColor = UIColor.white
    button.backgroundColor = UIColor.clear
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let cellTitle: UILabel = {
    let label = UILabel()
    label.text = "Your Voting Location"
    label.font = UIFont(name: "Avenir-Book", size: 23)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()
  
  let locationName: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Book", size: 17)
    label.minimumScaleFactor = 0.7
    label.adjustsFontSizeToFitWidth = true
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let address: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Book", size: 17)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.8
    
    return label
  }()
  
  let cardView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  let mapPin: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "map_pin_color")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  func buttonAction(_ button: UIButton) {
    print("LocationCell recognized tap")
    if let status = model.civicAPI.status.pollingAddress {
      if status == true {
        parentVC.performSegue(withIdentifier: "viewPollingAddress", sender: self)
      }
    }
  }
  
  func setupViews() {
    
    backgroundColor = customColors.lightGray
    
    addSubview(cardView)
    addSubview(tapRecognizer)
    cardView.addSubview(mapPin)
    cardView.addSubview(cellTitle)
    cardView.addSubview(locationName)
    cardView.addSubview(address)
    cardView.addSubview(cellTitle)
    bringSubview(toFront: tapRecognizer)
    
    tapRecognizer.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
    addConstraintsWithFormat("H:|[v0]|", views: tapRecognizer)
    addConstraintsWithFormat("V:|[v0]|", views: tapRecognizer)
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: cardView)
    addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0]-0-|", views: cardView)
    
    cardView.addConstraintsWithFormat("V:|-12-[v0]-12-|", views: mapPin)
    cardView.addConstraintsWithFormat("H:|-19-[v0(63)]-12-|", views: mapPin)
    
    cellTitle.topAnchor.constraint(equalTo: cardView.topAnchor, constant: viewConstants.MARGIN).isActive = true
    locationName.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: viewConstants.MARGIN).isActive = true
    address.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: viewConstants.MARGIN).isActive = true
    
    addConstraintsWithFormat("H:|-104-[v0]-14-|", views: cellTitle)
    addConstraintsWithFormat("H:|-104-[v0]-14-|", views: locationName)
    addConstraintsWithFormat("H:|-104-[v0]-14-|", views: address)
    
    
    if let location = model.pollingPlace {
      locationName.text = location.name
      address.text = location.line1
    }
    else {
      //When status is available, check for errors
      //Otherwise, text just says, "Loading..."
      if let status = model.civicAPI.status.pollingAddress {
        if status == false {
          locationName.text = "Currently unavailable"
          
        }
      }
    }
  }
}



