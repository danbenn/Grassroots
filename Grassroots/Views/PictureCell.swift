//
//  PictureCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 1/5/17.
//  Copyright © 2017 Daniel Bennett. All rights reserved.
//

import Foundation

import UIKit

class PictureCell: UICollectionViewCell {
  let profileImageView: CircleImageView = {
    let imageView = CircleImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    imageView.backgroundColor = UIColor.white
    imageView.layer.cornerRadius =
      imageView.frame.size.width / 2;
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  let header: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  
  func setupViews(_ person: Politician) {
    
    backgroundColor = customColors.lightGray
    addSubview(profileImageView)
    addSubview(header)
    
    profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    sendSubview(toBack: header)
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: header)
    addConstraintsWithFormat("V:|-75-[v0]-0-|", views: header)
    
    if let image = person.image {
      profileImageView.image = image
    }
  }
}


