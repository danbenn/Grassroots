//
//  District.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class District : Object {
    
    dynamic var city: String = ""
    dynamic var county: String = ""
    dynamic var congressional_district: String = ""
    dynamic var state_house_district: String = ""
    dynamic var state_senate_district: String = ""
    dynamic var council_district: String = ""
    
    //EFFECTS: Parses district JSON
    func parseDistrictJSON(divisions: JSON) {
        
        var districts = Array(divisions.dictionary!.keys)

        for (index, district) in districts.enumerate() {
            
            if district.containsString("county:") {
                county = divisions[district]["name"].stringValue
            }
            else if district.containsString("cd:") {
                congressional_district = divisions[district]["name"].stringValue
            }
            else if district.containsString("sldu:") {
                state_senate_district = divisions[district]["name"].stringValue
            }
            else if district.containsString("sldl:") {
                state_house_district = divisions[district]["name"].stringValue
            }
            
            districts[index] = "" //remove from search
            
        }
    }

}
