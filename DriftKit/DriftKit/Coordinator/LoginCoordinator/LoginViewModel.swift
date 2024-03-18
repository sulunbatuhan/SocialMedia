//
//  LoginViewModel.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth

final class LoginViewModel {
    
    weak var coordinator : LoginCoordinator?
    var onError     : ((String)->Void)?

    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func logIn(email:String, password:String) async -> Bool {
        do{
            try await AuthenticationManager.shared.logIn(with: email, password: password)
            return true
        }catch{
            return false
        }
    }
    
    
    func createNewAccount(){
        coordinator?.showRegisterCoordinator()
    }
    
    func checkConnection(){
        NotificationCenter.default.addObserver(forName: .networkNotification, object: nil, queue: .main) { bildirim in
            if bildirim.object as! Int == 0 {
                self.onError?("İnternet Bağlantı Hatası")
                
            }
        }
//        NetworkManager.shared.isReachable = { result in
//            print(result)
//            if result  == false {
//                self.onError?("İnternet Bağlantı Hatası")
//                print("internet baplantı hatası")
//            }
//        }
    }
    
    
}
