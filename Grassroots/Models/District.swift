//
//  District.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import SwiftyJSON

class District {
  
  var city: String = ""
  var county: String = ""
  var congressional_district: String = ""
  var state_house_district: String = ""
  var state_senate_district: String = ""
  var council_district: String = ""
  
  required init(divisions: JSON, city: String) {
    self.city = city
    
    if divisions.count > 0 {
      
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
}
