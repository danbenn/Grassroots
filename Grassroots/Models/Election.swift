//
//  Election.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation

class Election {
  
  let type: String
  let office: String
  let district: String
  let ballotIndex: Int
  
  var candidates = [Politician]()
  
  fileprivate var notification_pushed: Bool = false
  
  required init(type: String, office: String, district: String,
                ballotIndex: Int, democraticCandidate: Politician,
                republicanCandidate: Politician,
                independentCandidates: [Politician]) {
    
    self.type = type
    self.office = office
    self.district = district
    self.ballotIndex = ballotIndex
    
    //Builds candidates array with major party candidates at the beginning
    if democraticCandidate.name != "No opponent" {
      candidates.append(democraticCandidate)
    }
    if republicanCandidate.name != "No opponent" {
      candidates.append(republicanCandidate)
    }
    for person in independentCandidates {
      candidates.append(person)
    }
    
  }
  
  
  func userHasBeenNotified() -> Bool {
    if notification_pushed {
      return true
    }
    else {
      notification_pushed = true
      return false
    }
  }
  
  
  
  
}
