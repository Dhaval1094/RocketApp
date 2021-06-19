//
//  Rocket.swift
//  RocketLaunchApp
//
//  Created by Dhaval Trivedi on 31/05/21.
//

import Foundation

class Rocket: NSObject, Codable, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(rocket, forKey: "rocket")
        coder.encode(isBooked, forKey: "isBooked")
        coder.encode(id, forKey: "id")
    }
    
    required init?(coder: NSCoder) {
        rocket = coder.decodeObject(forKey: "rocket") as? RocketDetail
        isBooked = coder.decodeObject(forKey: "isBooked") as? Bool
        id = coder.decodeObject(forKey: "id") as? String
    }
    
    let rocket: RocketDetail?
    let isBooked: Bool?
    let id: String?
}

class RocketDetail: NSObject, Codable, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(__typename, forKey: "__typename")
        coder.encode(name, forKey: "name")
        coder.encode(type, forKey: "type")
    }
    
    required init?(coder: NSCoder) {
        __typename = coder.decodeObject(forKey: "__typename") as? String
        name = coder.decodeObject(forKey: "name") as? String
        type = coder.decodeObject(forKey: "type") as? String
    }
    
    let __typename: String?
    let name: String?
    let type: String?
}
