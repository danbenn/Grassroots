//
//  Referendum.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

class Referendum {
  let title: String
  let subtitle: String
  let url: String
  
  required init(title: String, subtitle: String, url: String) {
    self.title = title
    self.subtitle = subtitle
    self.url = url
  }
}