//
//  DistrictViewController.swift
//  sandbox
//
//  Created by Daniel Bennett on 7/14/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class DistrictViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource {
  
  @IBOutlet var politicianTable: UITableView!
  
  let cellReuseIdentifier = "politicianCell"
  
  var model: PoliticianDataModel!
  
  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbc = self.tabBarController as! PoliticianTabController
    model = tbc.model
    
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return model.politicians.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath:
    IndexPath) -> UITableViewCell {
    let cell = self.politicianTable.dequeueReusableCell(
      withIdentifier: cellReuseIdentifier) as! PoliticianCell
    
    let person = model.politicians[(indexPath as NSIndexPath).row]
    
    cell.politicianName?.text = person.name
    
    let myAttributedString = NSMutableAttributedString(
      string: person.office!,
      attributes: [NSFontAttributeName:UIFont(
        name: "Avenir",
        size: 16.0)!])
    
    cell.politicianTitle?.attributedText = myAttributedString
    
    if let image = model.politicians[(indexPath as NSIndexPath).row].image {
      cell.politicianImage.image = image
      createRoundImageView(cell)
    }
    else {
      cell.initials?.text = model.politicians[(indexPath as NSIndexPath).row].initials
      cell.politicianImage.image = nil
    }
    
    createRoundLabel(cell.initials)
    
    //check that the required image is loaded
    
    return cell
  }
  
  //EFFECTS: rounds ImageView, adds bright green border
  func createRoundImageView(_ cell: PoliticianCell) {
    cell.politicianImage.layer.cornerRadius =
      cell.politicianImage.frame.size.width / 2;
    cell.politicianImage.clipsToBounds = true
    cell.politicianImage.layer.borderWidth = 2
    cell.politicianImage.layer.borderColor = UIColor.green.cgColor
  }
  
  //EFFECTS: rounds label, adds bright green border
  fileprivate func createRoundLabel(_ label: UILabel) {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.clipsToBounds = true
    label.layer.borderWidth = 1
    label.layer.borderColor = UIColor.green.cgColor
  }
  
  func refreshUI() {
    DispatchQueue.main.async(execute: {
      self.politicianTable.reloadData()
    });
  }
  
}

