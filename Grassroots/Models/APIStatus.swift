//
//  APIStatus.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/15/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation

class APIStatus {
  
  var election: Bool?
  var district: Bool?
  var pollingAddress: Bool?
  var politicians: Bool?
  
  func markAsUnavailable(_ type: String, parameters: [String:String]) {
    print("error: unable to process \(type) API request")
    switch(type) {
    case "voterinfo":
      if parameters.count == 1 {
        self.pollingAddress = false
      }
      if parameters.count == 2 {
        self.election = false
      }
      break
    case "representatives":
      self.politicians = false
      self.district = false
      break
    default: print("error: unexpected request type of " + type)
    }
  }
  
}
