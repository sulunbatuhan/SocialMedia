//
//  RegisterViewModel.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {

   weak var coordinator : RegisterCoordinator?
    
    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
    }
    
    func createNewUser(username:String,email:String,password:String) async -> Bool{
        do {
            try await AuthenticationManager.shared.saveToDatabaseUser(email: email,username: username,password: password)
            return true
        }catch{
            return false
        }
       
//        AuthenticationManager.shared.newCreateUser(withEmail: email, username: username, password: password) {  [weak self] result in
//            switch result {
//            case .success(let success):
//               completion(true)
//            case .failure(let failure):
//               completion(false)
//            }
//        }
    }
    
    func backToLogin(){
        coordinator?.backLoginCoordinator()
    }
    
}
