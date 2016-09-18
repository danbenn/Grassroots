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
  let republicanCandidate: Politician
  let democraticCandidate: Politician
  let independentCandidates: [Politician]
  
  private var notification_pushed: Bool = false
  
  required init(type: String, office: String, district: String,
                ballotIndex: Int, democraticCandidate: Politician,
                republicanCandidate: Politician,
                independentCandidates: [Politician]) {
    
    self.type = type
    self.office = office
    self.district = district
    self.ballotIndex = ballotIndex
    self.democraticCandidate = democraticCandidate
    self.republicanCandidate = republicanCandidate
    self.independentCandidates = independentCandidates
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