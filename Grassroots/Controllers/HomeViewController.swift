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

var model = PoliticianDataModel()

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  let WIDTH_PADDING: CGFloat = 16
  let STANDARD_VIEW_HEIGHT: CGFloat = 115

  var refreshTimer = Timer()

  let material_green =
    UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)

  let lightGrayBackgroundColor =
    UIColor(red: 233/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1)

  let cellId = "politicianHead"

  let REFRESH_FREQUENCY: Double = 0.4

  @IBOutlet weak var politicianHeads: UICollectionView!

  //Election Cell Labels
  @IBOutlet weak var electionName: UILabel!
  @IBOutlet weak var electionSubHeader: UILabel!
  @IBOutlet weak var electionLowerSubHeader: UILabel!
  @IBOutlet weak var calendarMonth: UILabel!
  @IBOutlet weak var calendarDay: UILabel!

  //Location Cell Labels
  @IBOutlet weak var pollingAddress: UILabel!
  @IBOutlet weak var locationTitle: UILabel!
  @IBOutlet weak var locationName: UILabel!

  @IBOutlet weak var electionCell: ElectionCell!
  @IBOutlet weak var locationCell: LocationCell!

  //Button overlay so when electionCell is tapped, goes to sample ballot
  @IBOutlet weak var sampleBallotLink: UIButton!
  //Button overlay shows polling information when tapped
  @IBOutlet weak var pollingDetailLink: UIButton!


  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func setupPoliticianHeads() {
    if let layout = politicianHeads.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .vertical
    }
    politicianHeads.topAnchor.constraint(equalTo: locationCell.bottomAnchor, constant: WIDTH_PADDING).isActive = true

  }

  func refreshViews() {
    setupElectionCell()
    setupLocationCell()
    setupPoliticianHeads()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = lightGrayBackgroundColor

    model.address = UserDefaults.standard.object(forKey: "address") as! String
    model.politiciansAtAddress(politicianCompletionHandler)
    model.getElections(electionCompletionHandler)
    model.getPollingLocation(pollCompletionHandler)

    refreshViewForInterval()

  }

  //EFFECTS: refreshes LocationCell and ElectionCell views
  func refreshViewForInterval() {
    refreshTimer = Timer.scheduledTimer(timeInterval: REFRESH_FREQUENCY, target:
      self, selector: #selector(self.refreshViews), userInfo: nil, repeats: true)
    refreshTimer.fire()

    DispatchQueue.main.asyncAfter(deadline: (.now() + 10)) {
      self.refreshTimer.invalidate()
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
  
  

  //EFFECTS: formats text for "Upcoming Elections" cell
  func setupElectionCell() {
    calendarDay.layer.borderColor =
      UIColor.lightGray.cgColor
    calendarDay.layer.borderWidth = 1
    
    view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: electionCell)
    electionCell.heightAnchor.constraint(equalToConstant: STANDARD_VIEW_HEIGHT).isActive = true
    
    view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: politicianHeads)
    view.addConstraintsWithFormat("V:|-78-[v0]-12-[v1]-12-[v2]|", views: electionCell, locationCell, politicianHeads)
    
    electionName.topAnchor.constraint(equalTo: electionCell.topAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: electionName)
    
    electionSubHeader.topAnchor.constraint(equalTo: electionName.bottomAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: electionSubHeader)
    
    electionLowerSubHeader.topAnchor.constraint(equalTo: electionSubHeader.bottomAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: electionLowerSubHeader)
    
    if model.elections.count == 0 {
      electionSubHeader.text = "No upcoming elections"
      //lowerSubHeader!.text = "Notifications are: on"
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
      //lowerSubHeader!.text = "Notifications are: on"
    }

  }


  //EFFECTS: formats text for "My Voting Location" cell
  func setupLocationCell() {
    
    view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: locationCell)
    locationCell.heightAnchor.constraint(equalToConstant: STANDARD_VIEW_HEIGHT).isActive = true
    
    locationTitle.topAnchor.constraint(equalTo: locationCell.topAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: locationTitle)
    
    locationName.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: locationName)
    
    pollingAddress.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 6).isActive = true
    view.addConstraintsWithFormat("H:|-96-[v0]-14-|", views: pollingAddress)

    if let location = model.pollingPlace {
      locationName.text = location.name
      pollingAddress.text = location.line1
    }
    else {
      //When status is available, check for errors
      //Otherwise, text just says, "Loading..."
      if let status = model.civicAPI.status.pollingAddress {

        if status == false {
          locationName.text = "Currently unavailable"
          //selectionStyle = .none
        }
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    refreshUI()
    return model.politicians.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HeadshotCell
    cell.backgroundColor = UIColor.clear
    if model.politicians.count > indexPath.row {
      if let portrait = model.politicians[indexPath.row].image {
        cell.image.image = portrait
        createRoundImageView(&cell.image!)

      }
      cell.name.text = model.politicians[indexPath.row].last_name
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width / 2 - 30, height: self.view.frame.width / 2)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("collectionViewCell \(indexPath.row) was tapped")

  }

  //EFFECTS: rounds ImageView, adds bright green border
  func createRoundImageView(_ imageView: inout UIImageView) {
    imageView.layer.cornerRadius =
      imageView.frame.size.width / 2;
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2

    imageView.layer.borderColor = material_green.cgColor
  }









//  if (row == 0 && model.elections.count > 0) {
//  self.performSegue(withIdentifier: "viewBallot", sender: self)
//  }
//  if (row == 1 && model.elections.count > 0) {
//  self.performSegue(withIdentifier: "viewPollingLocation", sender: self)
//  }


  func refreshUI() {
    DispatchQueue.main.async(execute: {
      self.politicianHeads.reloadData()
    });
  }


}

extension Int {
  func times(f: () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
  }

  func times( f: @autoclosure () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
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
