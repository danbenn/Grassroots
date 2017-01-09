//
//  PoliticianDataModel.swift
//  sandbox
//
//  Created by Daniel Bennett on 7/21/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PoliticianDataModel {
  
  var elections   = [Election]()
  var referendums = [Referendum]()
  var politicians = [Politician]()
  var userDistrict: District?
  var pollingPlace: PollingPlace?
  var electionName: String?
  var electionDate: Date?
  
  let civicAPI = CivicAPI()
  
  var address = ""
  
  fileprivate func loadAddress() -> String {
    if let address:String = UserDefaults.standard.string(forKey: "address") {
      return address
    }
    else {
      return ""
    }
  }
  
  //REQUIRES: valid US voter address
  //EFFECTS:  gets current officials at local, state and federal level
  func politiciansAtAddress(_ completionHandler: @escaping (DataResponse<Any>) -> Void) {
    address = loadAddress()
    let parameters: [String: String] = ["address": address]
    
    civicAPI.request("representatives", parameters: parameters, handler: completionHandler)
    
  }
  
  //REQUIRES: valid US voter address
  //EFFECTS: requests detailed information on contests WITHIN the election
  func getElections(_ completionHandler: @escaping (DataResponse<Any>) -> Void) {
    address = loadAddress()
    let parameters: [String: String] = [
      "address": address//,
      //"electionId": "2000"
    ]
    civicAPI.request("voterinfo", parameters: parameters, handler: completionHandler)
  }
  
  //REQUIRES: valid US voter address
  //EFFECTS: requests election metadata such as date
  func getPollingLocation(_ completionHandler: @escaping (DataResponse<Any>) -> Void) {
    address = loadAddress()
    let parameters: [String: String] = ["address": address]
    civicAPI.request("voterinfo", parameters: parameters, handler: completionHandler)
  }
  
  //EFFECTS: sets polling place information
  func parsePollJSON(_ result: JSON) {
    if result["pollingLocations"].exists() {
      if result["pollingLocations"].count > 0 {
        let location = result["pollingLocations"][0]
        let name  = location["address"]["locationName"].stringValue.capitalized
        let line1 = location["address"]["line1"].stringValue.capitalized
        let city  = location["address"]["city"].stringValue.capitalized
        let state = location["address"]["state"].stringValue
        let zip   = location["address"]["zip"].stringValue
        let notes = location["notes"].stringValue.lowercased()
        let hours = location["pollingHours"].stringValue
        
        pollingPlace = PollingPlace(name: name, line1: line1,
                                    city: city, state: state, zip: zip,
                                    pollingHours: hours, notes: notes)
      }
    }
    else {
      civicAPI.status.pollingAddress = false
    }
    if result["election"].exists() {
      let name = result["election"]["name"].stringValue
      electionName = name
      let dateString = result["election"]["electionDay"].stringValue
      electionDate = Date(dateString: dateString)
    }
  }
  
  //EFFECTS: processes result of detailed election request
  func parseElectionJSON(_ result: JSON) {
    if result.count > 1 {
      let contests = result["contests"]
      //print(contests)
      for contest in contests.array! {
        
        let type = contest["type"].stringValue
        
        if type == "Referendum" {
          parseReferendumJSON(contest)
        }
        else {
          parseContestJSON(contest)
        }
      }
    }
  }
  
  //EFFECTS: deals with contests which are referendums
  //MODIFIES: referendums
  func parseReferendumJSON(_ referendum: JSON) {
    let title    = referendum["referendumTitle"].stringValue
    let subtitle = referendum["referendumSubtitle"].stringValue
    let url      = referendum["referendumUrl"].stringValue
    let ref = Referendum(title: title, subtitle: subtitle, url: url)
    referendums.append(ref)
  }
  
  
  //EFFECTS:  initializes contests, such as "Senator for Congress"
  //MODIFIES: elections
  func parseContestJSON(_ contest: JSON) {
    let type = contest["type"].stringValue
    let office = contest["office"].stringValue
    let district = contest["district"]["name"].stringValue
    let index = contest["ballotPlacement"].intValue
    
    var republican = Politician(name: "No opponent", party: "Republican", facebookID: "", city: "", state: "")
    var democrat = Politician(name: "No opponent", party: "Democratic", facebookID: "", city: "", state: "")
    var independents = [Politician]()
    
    //Initialize candidates
    if contest["candidates"].exists() {
      let candidates = contest["candidates"]
    
      for candidate in candidates.array! {
        let name = candidate["name"].stringValue
        let party = candidate["party"].stringValue
        let person: Politician!
        
        if candidate["photoUrl"].exists() {
          let imageURL = candidate["photoUrl"].stringValue
          person = Politician(name: name, party: party, imageURL: imageURL, city: "", state: "")
        }
        else {
          let id = facebookID(candidate)
          person = Politician(name: name, party: party, facebookID: id, city: "", state: "")
        }
        if party.range(of: "Democrat") != nil {
          democrat = person
        }
        else if party.range(of: "Republican") != nil {
          republican = person
        }
        else {
          independents.append(person)
        }
      }
      
      let election = Election(type: type, office: office,
        district: district, ballotIndex: index, democraticCandidate: democrat,
        republicanCandidate: republican, independentCandidates: independents)
      
      elections.append(election)
    }
  }
  
  //EFFECTS: opens referendum explanation PDF in browser window
  func openReferendumURL() {
    if referendums.count > 0 {
      let url = referendums[0].url
      let web_ready_url = url.replacingOccurrences(of: "\"",
        with: "", options: NSString.CompareOptions.literal, range: nil)
      
      if (UIApplication.shared.canOpenURL(
        URL(string: web_ready_url)!)) {
        UIApplication.shared.openURL(URL(string: web_ready_url)!)
      }
      
    }
  }
  
  //EFFECTS: opens driving directions to polling location on Google maps or Apple maps
  func requestDrivingDirections() {
    if let location = pollingPlace {
      let web_ready_address = location.line1.replacingOccurrences(
        of: " ", with: "+")
        + ",+" + location.city + "+" + location.state
      
      var URL = ""
      
      if (UIApplication.shared.canOpenURL(
        Foundation.URL(string: "comgooglemaps:")!)) {
        URL = "http://maps.google.com/?daddr=\(web_ready_address)"
      }
      else {
        URL = "http://maps.apple.com/?daddr=\(web_ready_address)"
      }
      
      UIApplication.shared.openURL(Foundation.URL(string: URL)!)
      
    }
  }
  
  
  //EFFECTS: Finds the Facebook ID of a candidate, e.g. BobForPresident
  //MODIFIES: facebookID
  func facebookID(_ candidate: JSON) -> String {
    if candidate["channels"].exists() {
      for channel in candidate["channels"].array! {
    
        if channel["type"].stringValue == "Facebook" {
          let facebookURL = channel["id"].stringValue
          
          let components = facebookURL.components(separatedBy: ".com/")
          
          let facebookID = components.last!
          
          print("\(candidate["name"]) -> \(facebookID)")
          
          return facebookID
        }
      }
    }
    return ""
  }
  
  
  //EFFECTS: processes politician JSON
  //MODIFIES: city
  func parsePoliticianJSON(_ result: JSON) {
    if result.count > 0 {
      let officials = result["officials"]
      let offices = result["offices"]
      let divisions = result["divisions"]
      let city = result["normalizedInput"]["city"].stringValue.capitalized
      
      userDistrict = District(divisions: divisions, city: city)
      
      initializePoliticians(officials)
      
      matchOfficesWithPoliticians(offices)
    }
    else {
      civicAPI.status.district = false
    }
  }
  
  //EFFECTS: creates polticians
  //MODIFIES: politicians
  func initializePoliticians(_ officials: JSON) {
    if officials.count > 0 {
      for person in officials.array! {
        let party = person["party"].stringValue
        let name = person["name"].stringValue
        
        print(person["add"])
        
        
        
       print(person["address"].exists)

    
        let city = ""
        let state = ""

        //print("city: \(city), state: \(state)")
                
        if (person["photoUrl"].exists()) {
          let imageURL = person["photoUrl"].stringValue
          politicians.append(Politician(name: name, party: party, imageURL: imageURL, city: city, state: state))
        }
        else {
          let id = facebookID(person)
          politicians.append(Politician(name: name, party: party, facebookID: id, city: city, state: state))
        }
      }
      
    }
  }
  
  //EFFECTS: matches job description with politician
  //MODIFIES: polticians
  fileprivate func matchOfficesWithPoliticians(_ offices: JSON) {
    if offices.count > 0 {
      for office in offices.array! {
        for person_index in office["officialIndices"].array! {
          politicians[person_index.int!].office = office["name"].stringValue
          //print(office["name"].stringValue)
        }
      }
    }
  }
  
  
  func notificationText() {
    //"Primary Election on
  }
  
  //func newElectionExists
  
}


