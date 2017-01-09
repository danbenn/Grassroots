//
//  PoliticianCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/16/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class PoliticianCell: UITableViewCell {
  
  let viewConstants = ViewConstants()
  
  var parentVC: HomeViewController!
  
  var politicianIndex = Int()
  
  //var parentVC: HomeViewController?
  
  let tapRecognizer: UIButton = {
    let button = UIButton()
    button.tintColor = UIColor.white
    button.backgroundColor = UIColor.clear
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let profileImage: CircleImageView = {
    let imageView = CircleImageView()
    imageView.createRoundBorder()
    imageView.backgroundColor = UIColor.clear
    imageView.layer.borderColor = customColors.material_green.cgColor
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let initials: CircleLabel = {
    let label = CircleLabel()
    label.font = UIFont(name: "Avenir-Book", size: 47)
    label.minimumScaleFactor = 0.8
    label.createRoundBorder()
    label.textAlignment = .center
    label.textColor = customColors.material_green
    label.backgroundColor = UIColor.clear
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let cardView: UIView = {
    let view = UIView()
    view.isUserInteractionEnabled = true
    view.backgroundColor = UIColor.white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let name: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Book", size: 21)
    label.backgroundColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    return label
  }()
  
  let position: UITextView = {
    let textView = UITextView()
    textView.font = UIFont(name: "Avenir-Book", size: 17)
    textView.isScrollEnabled = false
    textView.backgroundColor = UIColor.white
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
    return textView
  }()
  
  func buttonAction(_ button: UIButton) {
    print("PoliticianCell \(politicianIndex) recognized tap")
    
    
    parentVC.performSegue(withIdentifier: "viewProfile", sender: self)
    
  }
  
  func setupViews(_ rowIndex: Int) {
    
    politicianIndex = rowIndex
    profileImage.image = nil
    profileImage.isHidden = true
    name.text = ""
    position.text = ""
    initials.text = ""
    backgroundColor = customColors.lightGray
    
    addSubview(profileImage)
    addSubview(initials)
    addSubview(cardView)
    addSubview(tapRecognizer)
    
    cardView.addSubview(name)
    cardView.addSubview(position)
    
    tapRecognizer.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
    addConstraintsWithFormat("H:|[v0]|", views: tapRecognizer)
    addConstraintsWithFormat("V:|[v0]|", views: tapRecognizer)
    
    addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0]-0-|", views: cardView)
    
    addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0(\(frame.height - viewConstants.MARGIN))]-0-|", views: profileImage)
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0(\(frame.height - viewConstants.MARGIN))]" +
      "-\(viewConstants.MARGIN)-[v1]-\(viewConstants.MARGIN)-|", views: profileImage, cardView)
    
    initials.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
    initials.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    initials.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
    initials.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
    
    
    cardView.addConstraintsWithFormat("V:|-\(viewConstants.MARGIN * 2)-[v0]-" +
      "\(viewConstants.MARGIN/2)-[v1]-\(viewConstants.MARGIN)-|", views: name, position)
    
    cardView.addConstraintsWithFormat("H:|-\(viewConstants.MARGIN + 4)-[v0]-\(viewConstants.MARGIN)-|", views: name)
    cardView.addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: position)
    
    bringSubview(toFront: tapRecognizer)
    
    //Content mode must be set after restraints are applied
    profileImage.contentMode = .scaleAspectFit
    
    
    if model.politicians.count > rowIndex {
      
      let person = model.politicians[rowIndex]
      
      name.text = person.name
      
      if let image = person.image {
        profileImage.image = image
        profileImage.isHidden = false
        bringSubview(toFront: profileImage)
      }
      else {
        initials.text = person.initials
        profileImage.image = nil
        bringSubview(toFront: initials)
      }
      
      if var office = person.office {
        if person.party.contains("epublic") {
          office = office + " (R)"
        }
        else if person.party.contains("emocrat") {
          office = office + " (D)"
        }
        position.text = office
      }
      else {
        position.text = person.party
      }
      
      
      
      
       }
  }
}

