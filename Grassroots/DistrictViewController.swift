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
import Kingfisher

class DistrictViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var politicianTable: UITableView!
    
    let cellReuseIdentifier = "politicianCell"
    
    var model = PoliticianDataModel()
    
    //EFFECTS: initializes view controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbc = self.tabBarController as! PoliticianTabController
        model = tbc.model
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.politicians.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.politicianTable.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! PoliticianCell
        
        let person = model.politicians[indexPath.row]
        
        cell.politicianName?.text = person.name
        
        let myAttributedString = NSMutableAttributedString(
            string: person.office!,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir",
                size: 16.0)!])
        
        cell.politicianTitle?.attributedText = myAttributedString
        
        let filename = person.name.removeWhitespace()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let getImagePath = paths.stringByAppendingPathComponent(filename)
        let image = UIImage(contentsOfFile: getImagePath)
        
        if image != nil {
            cell.politicianImage.image = image!

            createRoundImageView(cell)
            
        }
        else {
            cell.politicianImage.image = UIImage(named: "blank_profile_picture")
            cell.politicianImage.layer.borderWidth = 0
            cell.politicianImage.clipsToBounds = false
            
        }
        
        //check that the required image is loaded
        
        return cell
    }
    
    func createRoundImageView(cell: PoliticianCell) {
        cell.politicianImage.layer.cornerRadius = cell.politicianImage.frame.size.width / 2;
        cell.politicianImage.clipsToBounds = true
        cell.politicianImage.layer.borderWidth = 2
        cell.politicianImage.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            self.politicianTable.reloadData()
        });
    }

}

