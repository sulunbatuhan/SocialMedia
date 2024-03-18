//
//  Post.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import Foundation
import FirebaseFirestore

struct PostModel : Codable,Hashable {
   
    
    let user       : User
    let postId     : String
    let postImage  : String
    let postText   : String?
//    let sharedDate : String
    
    init(user:User,post:Post) {
        self.user = user
        self.postId = post.postId
        self.postImage = post.postImage
        self.postText = post.postText
//        self.sharedDate = post
    }
    
    static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        return lhs.postId == rhs.postId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(postId)
    }

}
struct Post : Codable {
    
    let userID    : String
    let postId    : String
    let postImage : String
    let postText  : String
//    let sharedDate : String
    
    init(from decoder: Decoder) async throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.postId    = try container.decode(String.self, forKey: .postId)
        self.userID    = try container.decode(String.self, forKey: .userID)
        self.postImage = try container.decode(String.self, forKey: .postImage)
        self.postText  = try container.decode(String.self, forKey: .postText)
    }
    enum CodingKeys : String,CodingKey{
        case userID
        case postImage
        case postText
        case postId
//        case sharedDate
    }
}
