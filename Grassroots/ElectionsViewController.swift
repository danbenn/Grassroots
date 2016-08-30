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

class ElectionsViewController: UIViewController {
    
    @IBOutlet weak var electionName: UILabel!
    
    @IBOutlet weak var electionDate: UILabel!
    
    
    var model: PoliticianDataModel
    
    //EFFECTS: initializes view controller
    required init?(coder aDecoder: NSCoder) {
        self.model = PoliticianDataModel()
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

        
    
    //EFFECTS: sends voter's polling address to PollingAddressViewController
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "SendVoterInfoSegue" {
//            if let destination = segue.destinationViewController as? PollingAddressViewController {
//                destination.pollingLocation = model.pollingLocation
//            }
//        }
//        
//    }


    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            //self.myTableView.reloadData()
        });
    }

}

