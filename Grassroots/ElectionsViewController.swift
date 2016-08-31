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
        
        let tbc = self.tabBarController as! PoliticianTabController
        
        model = tbc.model
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.elections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ContestCell") as! ContestCell
        
        cell.office?.text = model.elections[indexPath.row].office
        
        for candidate in model.elections[indexPath.row].candidates {
            if candidate.party == "Republican" {
                cell.republican_initials?.text = initialsOfFullName(candidate.name)
                cell.republican_name?.text = candidate.name
                
                if candidate.imageURL != nil {
                    
                    let filename = candidate.name.removeWhitespace()
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                    let getImagePath = paths.stringByAppendingPathComponent(filename)
                    let image = UIImage(contentsOfFile: getImagePath)

                    cell.republican_image?.image = image
                    
                     createRoundImageView(cell.republican_image)
                }
            }
            else if candidate.party == "Democratic" {
                cell.democrat_initials?.text = initialsOfFullName(candidate.name)
                cell.democrat_name?.text = candidate.name
                
                
                if candidate.imageURL != nil {
                    let filename = candidate.name.removeWhitespace()
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                    let getImagePath = paths.stringByAppendingPathComponent(filename)
                    let image = UIImage(contentsOfFile: getImagePath)
                    
                    cell.democrat_image?.image = image
                    
                    createRoundImageView(cell.democrat_image)

                }
            }
        }
        
        createRoundLabel(cell.democrat_initials)
        
        createRoundLabel(cell.republican_initials)
    
        
        return cell
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
        //label.layer.borderWidth = 2
        //label.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    func initialsOfFullName(name: String) -> String {
        let separated_names = name.componentsSeparatedByString(" ")
        
        if separated_names.count == 2 {
            let first_initial: String = separated_names[0][0]
            let last_initial: String = separated_names[1][0]
            return first_initial + last_initial

        }
        else if separated_names.count == 3 {
            let first_initial: String = separated_names[0][0]
            let last_initial: String = separated_names[2][0]
            return first_initial + last_initial
        }
    
        else {
            print("error: unable to parse name into initials")
            return ""
        }
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


