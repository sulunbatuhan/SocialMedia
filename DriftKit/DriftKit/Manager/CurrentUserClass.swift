//
//  CurrentUserClass.swift
//  Social
//
//  Created by batuhan on 1.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CurrentUserClass{
    static func returnUserID()throws->String{
        guard let userID = Auth.auth().currentUser?.uid else {throw ErrorType.userNotFound}
        return userID
    }
}

class CollectionDocuments {
    static let collectionUsers  = Firestore.firestore().collection("Users")
}
