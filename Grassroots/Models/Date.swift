//
//  Date.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/9/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation

//DESCRIPTION: A custom date class for formatting the date
//             displayed on the home screen calendar widget

class Date {
  let stringValue: String
  let year:  String
  let month: String //e.g. NOV
  let day:   String //e.g. 08
  
  init(dateString: String) {
    let components = dateString.componentsSeparatedByString("-")
    if components.count == 3 {
      self.year  = components[0]
      self.month = components[1]
      self.day   = components[2]
      
    }
    else {
      print("error: unable to parse date string: \(dateString)")
      self.year  = ""
      self.month = ""
      self.day   = ""
    }
    
    stringValue = dateString
  }
  
  init() {
    self.stringValue = ""
    self.year        = ""
    self.month       = ""
    self.day         = ""
  }
  
  lazy var MMM: String = {
    [unowned self] in
    if self.month != "" {
      return self.monthName(Int(self.month)!)
    }
    else {
      return ""
    }
    
    }()
  
  
  private func monthName(month: Int) -> String {
    switch month {
    case 1:  return "JAN"
    case 2:  return "FEB"
    case 3:  return "MAR"
    case 4:  return "APR"
    case 5:  return "MAY"
    case 6:  return "JUN"
    case 7:  return "JUL"
    case 8:  return "AUG"
    case 9:  return "SEP"
    case 10: return "OCT"
    case 11: return "NOV"
    case 12: return "DEC"
    default: return ""
    }
  }
  
}