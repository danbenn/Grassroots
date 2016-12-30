//
//  CivicAPI.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/10/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CivicAPI {
  
  var status = APIStatus()
  
  fileprivate let civicApiBaseURL = "https://www.googleapis.com/civicinfo/v2/"
  fileprivate let apiKey = "?key=AIzaSyDnMrVJjPptjGc9KSDGkn_qZJ98wj_aZiQ"
  
  func request(_ type: String, parameters: [String:String],
               handler: @escaping (DataResponse<Any>) -> Void) {
    
    let URL = civicApiBaseURL + type + apiKey
    
    Alamofire
      .request(URL, parameters: parameters)
      .responseJSON { response in
        if response.result.isSuccess {
          
          let result = JSON(response.result.value!)
          
          if result["error"].exists() {
            
            self.status.markAsUnavailable(type, parameters: parameters)
          }
          else {
            handler(response)
          }
          
        }
        else {
          self.status.markAsUnavailable(type, parameters: parameters)
        }
    }
  }
  
}
