//
//  HomeViewController.swift
//  sandbox
//
//  Created by Daniel Bennett on 6/25/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource {
  
  @IBOutlet weak var newsFeedTable: UITableView!
  
  var tbc = PoliticianTabController()
  
  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tbc = tabBarController as! PoliticianTabController
    tbc.model.politiciansAtAddress(politicianCompletionHandler)
    tbc.model.getElections(electionCompletionHandler)
    tbc.model.getPollingLocation(pollCompletionHandler)
  }
  
  //EFFECTS: passes poll API response to the PoliticianDataModel
  fileprivate func pollCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result: JSON = JSON(response.result.value!) {
      tbc.model.parsePollJSON(result)
      refreshUI()
    }
  }
  
  //EFFECTS: passes election API response to the PoliticianDataModel
  fileprivate func electionCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result: JSON = JSON(response.result.value!) {
      tbc.model.parseElectionJSON(result)
      refreshUI()
    }
  }
  //EFFECTS: passes politician API response to the PoliticianDataModel
  fileprivate func politicianCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result: JSON = JSON(response.result.value!) {
      tbc.model.parsePoliticianJSON(result)
      refreshUI()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt
    indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath as NSIndexPath).row {
    case 0: return electionCellDelegate()
    case 1: return locationCellDelegate()
    case 2: return districtCellDelegate()
    default: return UITableViewCell()
    }
  }
  
  fileprivate func electionCellDelegate() -> ElectionCell {
    let cell = self.newsFeedTable.dequeueReusableCell(
      withIdentifier: "ElectionCell") as! ElectionCell!
    
    cell?.calendarDayLabel!.layer.borderColor =
      UIColor.lightGray.cgColor
    cell?.calendarDayLabel!.layer.borderWidth = 1
    
    if tbc.model.elections.count == 0 {
      cell?.subHeader!.text = "no elections in the next 2-4 weeks"
      //cell.lowerSubHeader!.text = "Notifications are: on"
    }
    else {
      if let name = tbc.model.electionName {
        cell?.statusLabel!.text = name
      }
      if let date = tbc.model.electionDate {
        cell?.calendarDayLabel!.text = date.day
        cell?.calendarMonthLabel!.text = date.MMM
        
      }
      cell?.subHeader!.text =
        "There are \(tbc.model.elections.count) upcoming contests"
      //cell.lowerSubHeader!.text = "Notifications are: on"
    }
    
    return cell!
    
  }
  
  fileprivate func locationCellDelegate() -> LocationCell {
    let cell = self.newsFeedTable.dequeueReusableCell(
      withIdentifier: "LocationCell") as! LocationCell!
    
    if let location = tbc.model.pollingPlace {
      cell?.locationName?.text = location.name
      cell?.locationAddress?.text = location.line1
    }
    else {
      if let available = tbc.model.civicAPI.status.pollingAddress {
        if !available {
          cell?.locationName?.text = "currently unavailable"
        }
        
      }
    }
    
    return cell!
  }
  
  fileprivate func districtCellDelegate() -> DistrictCell {
    let cell = self.newsFeedTable.dequeueReusableCell(
      withIdentifier: "DistrictCell") as! DistrictCell!
    
    if let available = tbc.model.civicAPI.status.district {
      if !available {
        cell?.user_city?.text = "currently unavailable"
      }
    }
    
    if let place = tbc.model.userDistrict {
      if place.city != "" && place.county != "" {
        cell?.user_city?.text = place.city + " (" + place.county + ")"
      }
      cell?.user_congressional_district?.text = place.congressional_district
      cell?.user_state_house_district?.text = place.state_house_district
      cell?.user_state_senate_district?.text = place.state_senate_district
    }
    
    
    return cell!
  }
  
  fileprivate func createRoundLabel(_ label: inout UILabel) {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.clipsToBounds = true
    label.layer.borderWidth = 2
    label.layer.borderColor = UIColor.green.cgColor
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
    switch (indexPath as NSIndexPath).row {
    case 0: return 115
    case 1: return 115
    case 2: return 175
    default: return 115
    }
  }
  
  func refreshUI() {
    DispatchQueue.main.async(execute: {
      self.newsFeedTable.reloadData()
    });
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section:
    Int) -> Int {
    return 3
  }
  
  func readJSONFromFile() {
    if let path = Bundle.main.path(
      forResource: "assets/test", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path),
                              options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj = JSON(data: data)
        if jsonObj != JSON.null {
          print("jsonData:\(jsonObj)")
        } else {
          print("could not get json from file")
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    } else {
      print("Invalid filename/path.")
    }
    
  }
  
}
