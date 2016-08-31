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
    
    var elections = [Election]()
    var politicians = [Politician]()
    var userDistrict: District?
    
    dynamic let address = "233 Blackrock Rd"//"2123 Welcome Way" //"6578 Brookhills Ct SE"
    
    dynamic let civicApiBaseURL = "https://www.googleapis.com/civicinfo/v2/"
    dynamic let apiKey = "?key=AIzaSyDnMrVJjPptjGc9KSDGkn_qZJ98wj_aZiQ"
    
    
    //REQUIRES: valid US voter address
    //EFFECTS:  gets current officials at local, state and federal level
    func politiciansAtAddress(completionHandler: (Response<AnyObject, NSError>) -> Void) {

        let voterInfoURL = civicApiBaseURL + "representatives" + apiKey
        let paramDictionary: [String: AnyObject] = ["address": address]
        
        Alamofire
            .request(.GET, voterInfoURL, parameters: paramDictionary)
            
            .responseJSON { response in
                
                if response.result.isSuccess {
                    completionHandler(response)
                }
                else {
                    print("error: unable to process API request")
                    print(response.result.error)
                    completionHandler(response)
                }
                
                
            }
    }
    
    func parseElectionJSON(result: JSON) {
        let contests = result["contests"]
        for contest in contests.array! {
            let name = contest["type"].stringValue
            let office = contest["office"].stringValue
            let district = contest["district"]["name"].stringValue
            let index = contest["ballotPlacement"].intValue
            
            //print(contest["candidates"].isExists())

            var people = [Politician]()
            
            if contest["candidates"].isExists() {
                let candidates = contest["candidates"]
                parseCandidateJSON(candidates, people: &people)
            }

            let election = Election(name: name, office: office,
                district: district, ballotIndex: index, candidates: people)
            
            elections.append(election)
        }
    }

    func parseCandidateJSON(candidates: JSON, inout people: [Politician]) {
        for candidate in candidates.array! {
            let name = candidate["name"].stringValue
            let party = candidate["party"].stringValue
            
            if candidate["photoUrl"].isExists() {
                let imageURL = candidate["photoUrl"].stringValue
                let person = Politician(name: name, party: party, imageURL: imageURL)
                people.append(person)
                
            }
            else {
                let person = Politician(name: name, party: party)
                people.append(person)
            }
        }
    }
    
    
    //EFFECTS: processes raw politician JSON
    //MODIFIES: city
    func parsePoliticianJSON(result: JSON) {
        let officials = result["officials"]
        let offices = result["offices"]
        let divisions = result["divisions"]
        
        userDistrict = District()
        
        userDistrict!.city = result["normalizedInput"]["city"].stringValue.capitalizedString
        
        userDistrict!.parseDistrictJSON(divisions)
        
        initializePoliticians(officials)
        
        matchOfficesWithPoliticians(offices)

    }

    //EFFECTS: creates polticians
    //MODIFIES: politicians
    func initializePoliticians(officials: JSON) {
        for person in officials.array! {
            let party = person["party"].stringValue
            let name = person["name"].stringValue
            
            if (person["photoUrl"].isExists()) {
                let imageURL = person["photoUrl"].stringValue
                politicians.append(Politician(name: name, party: party, imageURL: imageURL))
            }
            else {
                
                politicians.append(Politician(name: name, party: party))
            }
        }
    }

    //EFFECTS: matches job description with politician
    //MODIFIES: polticians
    func matchOfficesWithPoliticians(offices: JSON) {
        for office in offices.array! {
            for person_index in office["officialIndices"].array! {
                politicians[person_index.int!].office = office["name"].stringValue
                //print(office["name"].stringValue)
            }
        }
    }

    //EFFECTS: requests election data
    func getElections(completionHandler: (Response<AnyObject, NSError>) -> Void) {

        let electionInfoURL = civicApiBaseURL + "voterinfo" + apiKey
        
        let paramDictionary: [String:String] = [
            "address": address,
            "electionId": "2000"
        ]
        
        Alamofire
            .request(.GET, electionInfoURL, parameters: paramDictionary)
            
            .responseJSON { response in
                

                if response.result.isSuccess {
                    completionHandler(response)
                }
                else {
                    print("error: unable to process API request")
                    
                }
        }

    }
    
    func newElectionExists() {
        for election in elections {
            if election.userHasBeenNotified() {
                
            }
        }
    }
    
    func notificationText() {
        //"Primary Election on 
    }
    
    //func newElectionExists

}
