////
////  DistrictViewController.swift
////  sandbox
////
////  Created by Daniel Bennett on 7/14/16.
////  Copyright © 2016 Daniel Bennett. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Alamofire
//import SwiftyJSON
//import AlamofireImage
//
//class DistrictViewController: UIViewController, UITableViewDelegate,
//UITableViewDataSource {
//  
//  @IBOutlet var politicianTable: UITableView!
//  
//  let cellReuseIdentifier = "politicianCell"
//  
//  let material_green =
//    UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
//
//  //EFFECTS: initializes view controller
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//  }
//  
//  func tableView(tableView: UITableView!, didSelectRowAtIndexPath
//      indexPath: NSIndexPath!) {
//    print("You selected cell #\(indexPath.row)!")
//    let indexPath = tableView.indexPathForSelectedRow;
//    let currentCell = tableView.cellForRow(at:indexPath!) as! PoliticianCell
//    if let vc = self.storyboard!.instantiateViewController(withIdentifier:
//      "ProfileViewController") as? ProfileViewController {
//      vc.name = currentCell.politicianName.text!
//      performSegue(withIdentifier: "viewProfile", sender: self)
//    }
//    else {
//      print("error: view controller cast was unsuccessful")
//    }
//  }
//  
//  func tableView(_ tableView: UITableView,
//                 numberOfRowsInSection section: Int) -> Int {
//    return model.politicians.count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath:
//    IndexPath) -> UITableViewCell {
//    let cell = self.politicianTable.dequeueReusableCell(
//      withIdentifier: cellReuseIdentifier) as! PoliticianCell
//    
//    let person = model.politicians[(indexPath as NSIndexPath).row]
//    
//    cell.politicianName?.text = person.name
//    
//    var office = person.office!
//    
//    if person.party.contains("epublic") {
//      office = office + " (R)"
//    }
//    else if person.party.contains("emocrat") {
//      office = office + " (D)"
//    }
//    
//    let myAttributedString = NSMutableAttributedString(
//      string: office,
//      attributes: [NSFontAttributeName:UIFont(
//        name: "Avenir",
//        size: 16.0)!])
//    
//    cell.politicianTitle?.attributedText = myAttributedString
//    
//    if let image = person.image {
//      cell.politicianImage.image = image
//      createRoundImageView(cell)
//      refreshUI()
//    }
//    else {
//      cell.initials?.text = person.initials
//      cell.politicianImage.image = nil
//    }
//    cell.selectionStyle = .blue
//    cell.isUserInteractionEnabled = true
//    createRoundLabel(cell.initials)
//    
//    //check that the required image is loaded
//    
//    return cell
//  }
//  
//  //EFFECTS: rounds ImageView, adds bright green border
//  func createRoundImageView(_ cell: PoliticianCell) {
//    cell.politicianImage.layer.cornerRadius =
//      cell.politicianImage.frame.size.width / 2;
//    cell.politicianImage.clipsToBounds = true
//    cell.politicianImage.layer.borderWidth = 2
//    
//    cell.politicianImage.layer.borderColor = material_green.cgColor
//  }
//  
//  //EFFECTS: rounds label, adds bright green border
//  fileprivate func createRoundLabel(_ label: UILabel) {
//    label.layer.cornerRadius = label.frame.size.width / 2;
//    label.clipsToBounds = true
//    label.layer.borderWidth = 1
//    label.layer.borderColor = material_green.cgColor
//    label.textColor = material_green
//  }
//  
//  func refreshUI() {
//    DispatchQueue.main.async(execute: {
//      self.politicianTable.reloadData()
//    });
//  }
//  
//}
//
