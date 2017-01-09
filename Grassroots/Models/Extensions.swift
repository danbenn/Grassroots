//
//  CollectionViewCell.swift
//  Grassroots
//
//  Created by Daniel Bennett on 1/3/17.
//  Copyright © 2017 Daniel Bennett. All rights reserved.
//

import UIKit

extension UIImageView {
  func createRoundBorder() {
    layer.cornerRadius =
      frame.size.width / 2;
    clipsToBounds = true
    layer.borderWidth = 2
  }
}

extension UILabel {
  func createRoundBorder() {
    layer.cornerRadius = frame.size.width / 2;
    clipsToBounds = true
    layer.borderWidth = 1
    layer.borderColor = customColors.material_green.cgColor
  }
}

extension UIColor {
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  
}

extension UIView {
  
  func addConstraintsWithFormat(_ format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      viewsDictionary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
}

//EFFECTS: UIImageView variant which keeps edges round when size changes
class CircleLabel: UILabel {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let radius: CGFloat = self.bounds.size.width / 2.0
    
    self.layer.cornerRadius = radius
  }
}


//EFFECTS: UIImageView variant which keeps edges round when size changes
class CircleImageView: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let radius: CGFloat = self.bounds.size.width / 2.0
    
    self.layer.cornerRadius = radius
  }
}

//EFFECTS: allows string subscripting
extension String {
  
  subscript (i: Int) -> Character {
    return self[self.characters.index(self.startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
}
