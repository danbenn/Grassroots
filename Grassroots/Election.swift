//
//  Election.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation

class Election {
    dynamic var name: String = ""
    dynamic var office: String = ""
    dynamic var district: String = ""
    dynamic var ballotIndex: Int = 0
    private dynamic var notification_pushed: Bool = false
    
    var polling_places = [PollingPlace]()
    
    var candidates = [Politician]()
    
    init(name: String, office: String, district: String,
        ballotIndex: Int, candidates: [Politician]) {
        self.name = name
        self.office = office
        self.district = district
        self.ballotIndex = ballotIndex
        self.candidates = candidates
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
