//
//  Story.swift
//  Social
//
//  Created by batuhan on 30.01.2024.
//

import Foundation

final class Story : Codable {
    
    let user       : User
    let story      : String
//    let sharedDate : Date
    
    init(from decoder:Decoder/*dictionary : [String:Any]*/) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.story  = try container.decode(String.self, forKey: .story)
        self.user = try container.decode(User.self, forKey: .user)
//        self.story = dictionary["postImage"] as? String ?? ""
//        self.sharedDate = dictionary["sharedDate"] as? Date ?? Date()
    }
    
    enum CodingKeys :String, CodingKey{
        case user
        case story
//        case sharedDate : st\
    }
}


final class StoryModel {
    
    let user    : User
    var stories : [Story]
    
    init(user: User, stories: [Story]) {
        self.user = user
        self.stories = stories
    }
    
    
    
   
    
}
