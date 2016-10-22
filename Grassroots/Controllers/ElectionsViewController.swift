//
//  ElectionsViewController.swift
//  sandbox
//
//  Created by Daniel Bennett on 6/30/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ElectionsViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func referendumDetails(_ sender: AnyObject) {
    model.openReferendumURL()
  }
  
  var model: PoliticianDataModel
  
  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    self.model = PoliticianDataModel()
    super.init(coder: aDecoder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tbc = self.tabBarController as! PoliticianTabController
    
    model = tbc.model
    
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section:
    Int) -> Int {
    return model.elections.count + model.referendums.count
  }
  
  func initializeContestCell(_ cell: inout ContestCell, indexPath: IndexPath) {
    cell.office?.text = model.elections[(indexPath as NSIndexPath).row].office
    
    let candidates = model.elections[(indexPath as NSIndexPath).row].candidates
    let candidate1: Politician
    let candidate2: Politician
    
    if candidates.count >= 1 {
      candidate1 = candidates[0]
    }
    else {
      candidate1 = Politician(name: "", party: "", facebookID: "")
    }
  
    if candidates.count >= 2 {
      candidate2 = candidates[1]
    }
    else {
      candidate2 = Politician(name: "No opponent", party: "", facebookID: "")
    }

    
    cell.candidate1Name?.text = candidate1.name
    cell.candidate1Initials?.text = candidate1.initials
    cell.candidate1Party?.text = candidate1.party
    
    if let image = candidate1.image {
      cell.candidate1Image?.image = image
      createRoundImageView(cell.candidate1Image)
    }
    
    cell.candidate2Name?.text = candidate2.name
    cell.candidate2Initials?.text = candidate2.initials
    cell.candidate2Party?.text = candidate2.party
    
    if let image = candidate2.image {
      cell.candidate2Image?.image = image
      createRoundImageView(cell.candidate2Image)
    }
    else {
      
    }
  
    createRoundLabel(cell.candidate1Initials)
    createRoundLabel(cell.candidate2Initials)
    
    
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt
    indexPath: IndexPath) -> UITableViewCell {
    
    if (indexPath as NSIndexPath).row < model.elections.count {
      var cell = self.tableView.dequeueReusableCell(
        withIdentifier: "ContestCell") as! ContestCell
      initializeContestCell(&cell, indexPath: indexPath)
      return cell
      
    }
    else if (indexPath as NSIndexPath).row == model.elections.count {
      let cell = self.tableView.dequeueReusableCell(
        withIdentifier: "referendumTitleCell") as! ReferendumCell
      
      return cell
    }
    else {
      let cell = self.tableView.dequeueReusableCell(
        withIdentifier: "referendumContentCell") as! ReferendumCell
      let ref = model.referendums[(indexPath as NSIndexPath).row - model.elections.count - 1]
      let text = ref.title.capitalized + " - " + ref.subtitle.lowercased()
      
      let myAttributedString = NSMutableAttributedString(
        string: text,
        attributes: [NSFontAttributeName:UIFont(
          name: "Avenir",
          size: 16.0)!])
      
      cell.title.attributedText = myAttributedString
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath:
    IndexPath) -> CGFloat {
    if (indexPath as NSIndexPath).row < model.elections.count {
      return 190
    }
    else if (indexPath as NSIndexPath).row == model.elections.count {
      return 90
    }
    else {
      return 75
    }
  }
  
  func createRoundImageView(_ imageView: UIImageView) {
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 1
    imageView.layer.zPosition = 1
    imageView.layer.borderColor = UIColor.green.cgColor
  }
  
  
  fileprivate func createRoundLabel(_ label: UILabel) {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.clipsToBounds = true
    label.layer.borderWidth = 1
    label.layer.borderColor = UIColor.green.cgColor
  }
  
  
  
  func refreshUI() {
    DispatchQueue.main.async(execute: {
      //self.myTableView.reloadData()
    });
  }
  
  
}



extension String {
  
  subscript (i: Int) -> Character {
    return self[self.characters.index(self.startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
}


