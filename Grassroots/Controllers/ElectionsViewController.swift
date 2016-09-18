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
  
  @IBAction func referendumDetails(sender: AnyObject) {
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
  
  func tableView(tableView: UITableView, numberOfRowsInSection section:
    Int) -> Int {
    return model.elections.count + model.referendums.count
  }
  
  func initializeContestCell(inout cell: ContestCell, indexPath: NSIndexPath) {
    cell.office?.text = model.elections[indexPath.row].office
    
    let democrat   = model.elections[indexPath.row].democraticCandidate
    let republican = model.elections[indexPath.row].republicanCandidate
    
    cell.democrat_name?.text = democrat.name
    cell.democrat_initials?.text = democrat.initials
    
    if let image = democrat.image {
      cell.democrat_image?.image = image
      createRoundImageView(cell.democrat_image)
    }
    
    cell.republican_name?.text = republican.name
    cell.republican_initials?.text = republican.initials
    
    if let image = republican.image {
      cell.republican_image?.image = image
      createRoundImageView(cell.republican_image)
    }
    
    createRoundLabel(cell.democrat_initials)
    createRoundLabel(cell.republican_initials)
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
    
    if indexPath.row < model.elections.count {
      var cell = self.tableView.dequeueReusableCellWithIdentifier(
        "ContestCell") as! ContestCell
      initializeContestCell(&cell, indexPath: indexPath)
      return cell
      
    }
    else if indexPath.row == model.elections.count {
      let cell = self.tableView.dequeueReusableCellWithIdentifier(
        "referendumTitleCell") as! ReferendumCell
      
      return cell
    }
    else {
      let cell = self.tableView.dequeueReusableCellWithIdentifier(
        "referendumContentCell") as! ReferendumCell
      let ref = model.referendums[indexPath.row - model.elections.count - 1]
      let text = ref.title.capitalizedString + " - " + ref.subtitle.lowercaseString
      
      let myAttributedString = NSMutableAttributedString(
        string: text,
        attributes: [NSFontAttributeName:UIFont(
          name: "Avenir",
          size: 16.0)!])
      
      cell.title.attributedText = myAttributedString
      return cell
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:
    NSIndexPath) -> CGFloat {
    if indexPath.row < model.elections.count {
      return 190
    }
    else if indexPath.row == model.elections.count {
      return 90
    }
    else {
      return 75
    }
  }
  
  func createRoundImageView(imageView: UIImageView) {
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.greenColor().CGColor
  }
  
  
  private func createRoundLabel(label: UILabel) {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.clipsToBounds = true
    label.layer.borderWidth = 1
    label.layer.borderColor = UIColor.greenColor().CGColor
  }
  
  func refreshUI() {
    dispatch_async(dispatch_get_main_queue(),{
      //self.myTableView.reloadData()
    });
  }
  
  
}



extension String {
  
  subscript (i: Int) -> Character {
    return self[self.startIndex.advancedBy(i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    let start = startIndex.advancedBy(r.startIndex)
    let end = start.advancedBy(r.endIndex - r.startIndex)
    return self[Range(start ..< end)]
  }
  
  var html2AttributedString: NSAttributedString? {
    guard
      let data = dataUsingEncoding(NSUTF8StringEncoding)
      else { return nil }
    do {
      return try NSAttributedString(data: data, options:
        [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
          NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding],
                                    documentAttributes: nil)
    } catch let error as NSError {
      print(error.localizedDescription)
      return  nil
    }
  }
  var html2String: String {
    return html2AttributedString?.string ?? ""
  }
}


