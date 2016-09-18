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
  
  private let civicApiBaseURL = "https://www.googleapis.com/civicinfo/v2/"
  private let apiKey = "?key=AIzaSyDnMrVJjPptjGc9KSDGkn_qZJ98wj_aZiQ"
  
  func request(type: String, parameters: [String:String],
               handler: (Response<AnyObject, NSError>) -> Void) {
    
    let URL = civicApiBaseURL + type + apiKey
    
    Alamofire
      .request(.GET, URL, parameters: parameters)
      .responseJSON { response in
        if response.result.isSuccess {
          
          let result = JSON(response.result.value!)
          
          if result["error"].isExists() {
            
            //TO BE IMPLEMENTED: detection of invalid addresses
            //                        let message = result["error"][
            //                            "errors"].array!.first!["message"].stringValue
            //
            //                        if message == "Failed to parse address" {
            //
            //                        }
            
            self.status.markAsUnavailable(type, parameters: parameters)
          }
          handler(response)
        }
        else {
          self.status.markAsUnavailable(type, parameters: parameters)
        }
    }
  }
  
}
