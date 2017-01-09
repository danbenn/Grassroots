//
//  NewsFeedswift
//  Grassroots
//
//  Created by Daniel Bennett on 8/16/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

class ElectionCell: UITableViewCell {
  
  var parentVC: HomeViewController!
  
  let viewConstants = ViewConstants()
  //var parentVC: UIViewController?
  
  let tapRecognizer: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.clear
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  func buttonAction(sender: UIButton) {
    print("ElectionCell recognized tap")
    if model.elections.count > 0 {
      parentVC.performSegue(withIdentifier: "viewBallot", sender: self)
    }
  }
  
  let calendarMonth: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.rgb(red: 231, green: 87, blue: 79)
    label.textColor = UIColor.white
    label.font = UIFont(name: "Avenir-Book", size: 17)
    label.textAlignment = .center
    return label
  }()
  
  let calendarDay: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.layer.borderColor =
      UIColor.lightGray.cgColor
    label.backgroundColor = UIColor.clear
    label.layer.borderWidth = 1
    label.textAlignment = .center
    label.font = UIFont(name: "Avenir-Book", size: 47)
    return label
  }()
  
  let electionName: UILabel = {
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Avenir-Book", size: 23)
    label.text = "Upcoming Elections"
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()
  
  let electionSubHeader: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont(name: "Avenir-Book", size: 17)
    label.minimumScaleFactor = 0.8
    return label
  }()
  
  let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    return view
  }()
  
  func addSubviews() {
    addSubview(cardView)
    addSubview(tapRecognizer)
    cardView.addSubview(calendarDay)
    cardView.addSubview(calendarMonth)
    cardView.addSubview(electionName)
    cardView.addSubview(electionSubHeader)
  }
  
  func addConstraints() {
    addConstraintsWithFormat("H:|[v0]|", views: tapRecognizer)
    addConstraintsWithFormat("V:|[v0]|", views: tapRecognizer)
    
    addConstraintsWithFormat("H:|-\(viewConstants.MARGIN)-[v0]-\(viewConstants.MARGIN)-|", views: cardView)
    addConstraintsWithFormat("V:|-\(viewConstants.MARGIN)-[v0]-0-|", views: cardView)
    
    cardView.addConstraintsWithFormat("H:|-12-[v0(81)]-12-[v1]-6-|", views: calendarMonth, electionName)
    cardView.addConstraintsWithFormat("H:|-12-[v0(81)]-12-[v1]-6-|", views: calendarDay, electionSubHeader)
    
    cardView.addConstraintsWithFormat("V:|-12-[v0(24)]-0-[v1(65)]-24-|", views: calendarMonth, calendarDay)
    
    electionName.topAnchor.constraint(equalTo: cardView.topAnchor, constant: viewConstants.MARGIN).isActive = true
    electionName.widthAnchor.constraint(equalToConstant: 36).isActive = true
    
    electionSubHeader.topAnchor.constraint(equalTo: electionName.bottomAnchor, constant: viewConstants.MARGIN).isActive = true
    electionName.widthAnchor.constraint(equalToConstant: 31).isActive = true
    
  }
  
  
  func setupViews() {
    
    addSubviews()
    addConstraints()
    
    backgroundColor = customColors.lightGray
    
    tapRecognizer.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
    
    bringSubview(toFront: tapRecognizer)
    
    if model.elections.count == 0 {
      electionSubHeader.text = "No upcoming elections"
    }
    else {
      if let name = model.electionName {
        electionName.text = name
      }
      if let date = model.electionDate {
        calendarDay.text = date.day
        calendarMonth.text = date.MMM
      }
      electionSubHeader.text =
      "\(model.elections.count) upcoming contests"
    }
  }
}



