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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
       
    }
    
    private func politicianCompletionHandler(response: Response<AnyObject, NSError>) {
        let result = JSON(response.result.value!)
        tbc.model.parsePoliticianJSON(result)
        refreshUI()
    }

   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    private func electionCellDelegate() -> ElectionCell {
        let cell = self.newsFeedTable.dequeueReusableCellWithIdentifier("ElectionCell") as! ElectionCell!
        cell.calendarDayLabel!.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        if (tbc.model.elections.count == 0) {
            cell.calendarDayLabel!.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.statusLabel!.text = "Upcoming Elections"
            cell.subHeader!.text = "no elections in your area for the next 2-4 weeks"
            cell.lowerSubHeader!.text = "we'll send a notification before the next one comes up!"
        }
        else {
            cell.statusLabel!.text = "You have \(tbc.model.elections.count) upcoming elections"
        }
        return cell

    }
    
    private func locationCellDelegate() -> LocationCell {
        let cell = self.newsFeedTable.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell!
        
        if (tbc.model.elections.count == 0) {
            cell.statusLabel!.text = "Your Voting Location"
            cell.subHeader!.text   = "Can't fetch polling location at the moment"
            //cell.lowerSubHeader!.text = "To find it manually, tap below: "
            //cell.button.setTitle("Find Polling Location", forState: UIControlState.Normal)
        }
        else {
            cell.statusLabel!.text = "You have \(tbc.model.elections.count) upcoming elections"
        }
        return cell

    }
    
    private func districtCellDelegate() -> DistrictCell {
        let cell = self.newsFeedTable.dequeueReusableCellWithIdentifier("DistrictCell") as! DistrictCell!
        
        if let place = tbc.model.userDistrict {
            cell.user_city?.text = place.city + " (" + place.county + ")"

            cell.user_congressional_district?.text = place.congressional_district
            
            cell.user_state_house_district?.text = place.state_house_district

            cell.user_state_senate_district?.text = place.state_senate_district
            
            cell.user_council_district?.text = place.council_district
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return electionCellDelegate()
        }
        if indexPath.row == 1 {
            return locationCellDelegate()
        }
        if indexPath.row == 2 {
            return districtCellDelegate()
        }
        return UITableViewCell()
    }
    
    private func createRoundLabel(inout label: UILabel) {
        label.layer.cornerRadius = label.frame.size.width / 2;
        label.clipsToBounds = true
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 115
        case 1: return 115
        case 2: return 200
        default: return 115
        }
    }

    
    func electionCompletionHandler(response: Response<AnyObject, NSError>) {
        //print(response)
        if response.result.isFailure {
            
        }
        else {
            let result = JSON(response.result.value!)
            
            if result.count > 1 {
                tbc.model.parseElectionJSON(result)
            }
                        
            refreshUI()
        }
    }
    
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            self.newsFeedTable.reloadData()
        });
    }
    
    func readJSONFromFile() {
        if let path = NSBundle.mainBundle().pathForResource("assets/test", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    print("jsonData:\(jsonObj)")
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

    }
    
    //EFFECTS: determines if app has launched before
    //MODIFIES: NSUserDefaults
    func appHasLaunchedBefore() -> Bool {
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if launchedBefore {
            return true
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
            return false
        }
    }
    
}
