//
//  Election.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Election : Object {
    dynamic var name: String = ""
    dynamic var district: String = ""
    dynamic var ballotIndex: Int = 0
    private dynamic var notification_pushed: Bool = false
    
    var polling_places = List<PollingPlace>()
    
    var candidates = List<Politician>()
    
    required init() {
        super.init()
    }
    
    convenience init(name: String, district: String, ballotIndex: Int, candidates: List<Politician>) {
        self.init()
        self.name = name
        self.district = district
        self.ballotIndex = ballotIndex
        self.candidates = candidates
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
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
