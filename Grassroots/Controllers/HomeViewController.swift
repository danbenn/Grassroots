//
//  HomeViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 1/4/17.
//  Copyright © 2017 Daniel Bennett. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var model = PoliticianDataModel()

struct CustomColors {
  let material_green =
    UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
  
  let lightGray =
    UIColor(red: 233/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1)
}

struct ViewConstants {
  let CARD_VIEW_HEIGHT: CGFloat = 125
  let POLITICIAN_CELL_HEIGHT: CGFloat = 140
  let MARGIN: CGFloat = 8
}

let customColors  = CustomColors()
let viewConstants = ViewConstants()

class HomeViewController: UITableViewController {
  
  var numRefreshes: Int = 0
  
  let MAX_NUM_REFRESHES = 15
  
  func setupTableView() {
    tableView.separatorColor = UIColor.clear
    tableView.backgroundColor = customColors.lightGray
    tableView.contentInset = UIEdgeInsetsMake(0, 0, viewConstants.MARGIN, 0)
    
    self.tableView.register(ElectionCell.self, forCellReuseIdentifier: "ElectionCell")
    self.tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
    self.tableView.register(PoliticianCell.self, forCellReuseIdentifier: "PoliticianCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Home"
    
    setupTableView()
    
    model.address = UserDefaults.standard.object(forKey: "address") as! String
    model.politiciansAtAddress(politicianCompletionHandler)
    model.getElections(electionCompletionHandler)
    model.getPollingLocation(pollCompletionHandler)
    
    
    Timer.scheduledTimer(timeInterval: 0.4,
                         target: self,
                         selector: #selector(self.updateViews),
                         userInfo: nil,
                         repeats: true)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "viewProfile" ,
      let nextVC = segue.destination as? ProfileViewController ,
      let cell = sender as? PoliticianCell {
      
      nextVC.index = cell.politicianIndex
    }
  }
  
  func updateViews() {
    if (numRefreshes < MAX_NUM_REFRESHES) {
      refreshUI()
      numRefreshes = numRefreshes + 1
    }
  }
  
  //EFFECTS: passes poll API response to the PoliticianDataModel
  fileprivate func pollCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result = response.result.value {
      model.parsePollJSON(JSON(result))
    }
  }
  
  //EFFECTS: passes election API response to the PoliticianDataModel
  fileprivate func electionCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result = response.result.value {
      model.parseElectionJSON(JSON(result))
    }
  }
  //EFFECTS: passes politician API response to the PoliticianDataModel
  fileprivate func politicianCompletionHandler(_ response:
    DataResponse<Any>) {
    if let result = response.result.value {
      model.parsePoliticianJSON(JSON(result))
    }
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.politicians.count + 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ElectionCell", for: indexPath) as! ElectionCell
      cell.parentVC = self
      cell.setupViews()
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
      cell.parentVC = self
      cell.setupViews()
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PoliticianCell", for: indexPath) as! PoliticianCell
      cell.parentVC = self
      cell.setupViews(indexPath.row - 2)
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0...1:
      return viewConstants.CARD_VIEW_HEIGHT
    default:
      return viewConstants.POLITICIAN_CELL_HEIGHT
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("tableView registered tap")
  }
  
  func refreshUI() {
    DispatchQueue.main.async(execute: {
      self.tableView?.reloadData()
    });
  }
  
  
  
}

