//
//  ProfileCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 1/1/17.
//  Copyright © 2017 Daniel Bennett. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
  
  let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    return view
  }()
  
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont(name: "Avenir", size: 20)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let positionLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.darkGray
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    label.font = UIFont(name: "Avenir", size: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let locationLabel: UILabel = {
    let label = UILabel()
    //label.text = "Lives in Miami, FL"
    label.textColor = UIColor.darkGray
    label.font = UIFont(name: "Avenir", size: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func setupViews(_ person: Politician) {
    
    addSubview(cardView)
    cardView.addSubview(nameLabel)
    cardView.addSubview(positionLabel)
    cardView.addSubview(locationLabel)
    
    
    nameLabel.text = person.name
    positionLabel.text = person.office
    
    
    //print("city: \(person.city), state: \(person.state)")
    
    
    let attributedText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
    
    attributedText.append(NSAttributedString(string: "\(person.city), \(person.state)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:
      UIColor.rgb(red: 155, green: 161, blue: 161)]))
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4
    
    attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
    
    let attachment = NSTextAttachment()
    attachment.image = #imageLiteral(resourceName: "map_pin_color.png")
    attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
    attributedText.append(NSAttributedString(attachment: attachment))
    
    //locationLabel.attributedText = attributedText
    locationLabel.text = "                 ";
    

    
    
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: cardView)
    addConstraintsWithFormat("V:|-0-[v0]-0-|", views: cardView)
    
    
    addConstraintsWithFormat("V:|-6-[v0]-6-[v1]-6-[v2]-12-|", views: nameLabel, positionLabel, locationLabel)
    
    
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: nameLabel)
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: positionLabel)
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: locationLabel)
    
    
  }
}

