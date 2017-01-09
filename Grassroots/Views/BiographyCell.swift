//
//  BiographyCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 1/1/17.
//  Copyright © 2017 Daniel Bennett. All rights reserved.
//

import UIKit

class BiographyCell: UICollectionViewCell {
  
  let viewConstants = ViewConstants()
  
  let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    return view
  }()
  
  let textView: UITextView = {
    let view = UITextView()
    view.font = UIFont(name: "Avenir-Book", size: 17)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    view.isScrollEnabled = false
    view.isSelectable = false
    return view
  }()
  
  
  
  func setupViews(_ person: Politician) {
    backgroundColor = customColors.lightGray
    
    addSubview(cardView)
    cardView.addSubview(textView)
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: cardView)
    addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: cardView)
    
    cardView.addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: textView)
    cardView.addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: textView)
    
    textView.text = "Candidate bios coming soon!"
    textView.textAlignment = .center
    
    
    textView.font = UIFont(name: "Avenir", size: 16)
    
  }
}


