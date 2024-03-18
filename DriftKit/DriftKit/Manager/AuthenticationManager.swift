//
//  AuthenticationManager.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

enum ErrorType : Error {
    case userExist
    case userNotFound
    case notAdded
    case authError
    case fetchingError
}

protocol AuthenticationManagerProtocol {
    func newCreateUser(withEmail email : String,username:String,password : String,completion:@escaping(Result<Bool,ErrorType>)->())
    func logInForUser(emailAdress : String, password:String,completion:@escaping (Bool)->())
    func checkUserAuth()->Bool
    func signOut(completion:@escaping(Bool)->())
}

public class AuthenticationManager {
  
    private init(){  }
    static let shared            = AuthenticationManager()
    private let collectionUsers  =  Firestore.firestore().collection("Users")
    
    private func userDocument(userId:String) -> DocumentReference{
        collectionUsers.document(userId)
    }
    
    
    func isUserExist(with email:String,username:String) async throws -> Bool {
        return false
    }
    
    func logIn(with email : String,password:String) async throws{
       try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func createNewUser(withEmail email : String,password:String)async throws -> AuthDataResult {
      return try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func insertUser(with email : String,username:String,userID :String) async throws{
        
        let currentDate             = Date.now
        let userData : [String:Any] = ["userID":userID,
                                       "username":username,
                                       "email":email,
                                       "createdDate":currentDate,
                                       "userImage":"",
                                       "backgroundImage":""]
        try await userDocument(userId: userID).setData(userData)
    }
    
    func saveToDatabaseUser(email:String,username:String? = nil,password:String) async throws{
    let result = try await isUserExist(with: email, username: password)
        
        if result == false {
            let authResult = try await createNewUser(withEmail: email, password: password)
            try await insertUser(with: email, username: username ?? "", userID: authResult.user.uid)
        }
    }
    
    
    func checkUserAuth()->Bool{
        if Auth.auth().currentUser == nil {
            return false
        }else {
            return true
        }
    }
  
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    
    
 
    
//    func newCreateUser(withEmail email : String,username:String,password : String,completion:@escaping(Result<Bool,ErrorType>)->()){
//        DispatchQueue.main.async {
//            DatabaseManager.shared.isUserExist(with: email, username: username){ [weak self] isExist in
//                if isExist{
//                    return completion(.failure(.userExist))
//                }else {
//                    
//                    //                   let AuthDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//                    //                    AuthDataResult.user.photoURL
//                    
//                    Auth.auth().createUser(withEmail: email, password: password) { [weak self ] result, error in
//                        guard let strongSelf = self else {return}
//                        guard error == nil,result != nil else {return completion(.failure(.authError)) }
//                        
//                        DatabaseManager.shared.insertUser(with: email, username: username,userID : result?.user.uid ?? "") { success in
//                            if success {
//                                return completion(.success(true))
//                            }else {
//                                return completion(.failure(.notAdded) )
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
    func logInForUser(emailAdress : String, password:String,completion:@escaping (Bool)->()){
        Auth.auth().signIn(withEmail: emailAdress, password: password) { [weak self ] result , error in
            guard let strongSelf = self else {return}
            if error != nil,result == nil {
//                strongSelf.isLoggedIn = false
                completion(false)
            }else {
//                strongSelf.isLoggedIn = true
                completion(true)
            }
        }
    }
    
  

   
    
}
