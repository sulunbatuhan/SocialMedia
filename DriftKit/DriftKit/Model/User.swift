//
//  User.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import Foundation
//
//struct User : Codable {
//    let userID : String
//    let username:String
//    let email:String
//    let aboutYou:String?
//    let createdDate : String?
//    let userImage : String?
//    let backgroundImage : String?
//    
//    init(dictionary:[String:Any]) {
//        self.aboutYou = dictionary["aboutYou"] as? String ?? ""
//        self.userID = dictionary["userID"] as? String ?? ""
//        self.username = dictionary["username"] as? String ?? ""
//        self.email = dictionary["email"] as? String ?? ""
//        self.userImage = dictionary["userImage"] as? String ?? ""
//        self.backgroundImage = dictionary["backgroundImage"] as? String ?? ""
//        self.createdDate = dictionary["createdDate"] as? String ?? ""
//    }
//    enum CodingKeys : String,CodingKey {
//        case userID
//        case username
//        case email
//        case aboutYou
//        case createdDate
//        case userImage
//        case backgroundImage
//    }
    
//}
struct User:Codable {
    
    let userID          : String
    let username        : String
    let email           : String
    let aboutYou        : String?
    let userImage       : String?
    let backgroundImage : String?
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.userID    = try container.decode(String.self, forKey: .userID)
        self.username  = try container.decode(String.self, forKey: .username)
        self.email     = try container.decode(String.self, forKey: .email)
//        self.createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        self.userImage = try container.decodeIfPresent(String.self, forKey: .userImage)
        self.aboutYou  = try container.decodeIfPresent(String.self, forKey: .aboutYou)
        self.backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
    }

    enum CodingKeys : String,CodingKey {
        case userID
        case username
        case email
        case aboutYou
//        case createdDate
        case userImage
        case backgroundImage
    }
}
