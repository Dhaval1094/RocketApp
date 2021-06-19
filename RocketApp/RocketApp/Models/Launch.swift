//
//  Launch.swift
//  RocketLaunchApp
//
//  Created by Dhaval Trivedi on 01/06/21.
//

import Foundation

class LaunchConnection: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(__typename, forKey: "__typename")
        coder.encode(cursor, forKey: "cursor")
        coder.encode(hasMore, forKey: "hasMore")
        coder.encode(launches, forKey: "launches")
    }
    
    required init?(coder: NSCoder) {
        __typename = coder.decodeObject(forKey: "__typename") as? String
        cursor = coder.decodeObject(forKey: "cursor") as? String
        hasMore = coder.decodeObject(forKey: "hasMore") as? Bool
        launches = coder.decodeObject(forKey: "launches") as? [Launches]
    }
    
    let __typename : String?
    let cursor : String?
    let hasMore : Bool?
    let launches : [Launches]?
}

class Launches: NSObject, NSCoding, Codable {
    
    func encode(with coder: NSCoder) {
        coder.encode(__typename, forKey: "__typename")
        coder.encode(id, forKey: "id")
        coder.encode(mission, forKey: "mission")
        coder.encode(site, forKey: "site")
    }
    
    required init?(coder: NSCoder) {
        __typename = coder.decodeObject(forKey: "__typename") as? String
        id = coder.decodeObject(forKey: "id") as? String
        mission = coder.decodeObject(forKey: "mission") as? Mission
        site = coder.decodeObject(forKey: "site") as? String
    }
    
    let __typename: String?
    let id: String?
    let mission: Mission?
    let site: String?
}

class Mission: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(__typename, forKey: "__typename")
        coder.encode(missionPatch, forKey: "missionPatch")
        coder.encode(name, forKey: "name")
        coder.encode(site, forKey: "site")
    }
    
    required init?(coder: NSCoder) {
        __typename = coder.decodeObject(forKey: "__typename") as? String
        missionPatch = coder.decodeObject(forKey: "missionPatch") as? String
        name = coder.decodeObject(forKey: "name") as? String
        site = coder.decodeObject(forKey: "site") as? String
    }
    
    let __typename: String?
    let missionPatch: String?
    let name: String?
    let site: String?
}
