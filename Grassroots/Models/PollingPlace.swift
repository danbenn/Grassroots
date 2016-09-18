//
//  PollingPlace.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation

class PollingPlace {
  let name: String
  let line1: String
  let city: String
  let state: String
  let zip: String
  let pollingHours: String
  let notes: String
  
  required init(name: String, line1: String, city: String,
                state: String, zip: String,
                pollingHours: String, notes: String) {
    self.name = name
    self.line1 = line1
    self.city = city
    self.state = state
    self.zip = zip
    self.pollingHours = pollingHours
    self.notes = notes
  }
}
