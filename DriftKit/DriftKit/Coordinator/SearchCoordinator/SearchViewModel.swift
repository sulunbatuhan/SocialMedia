//
//  SearchViewModel.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import FirebaseAuth
import Combine

protocol SearchModelProtocol{
    
}

final class SearchViewModel{
   
    weak var coordinator : SearchCoordinator?
    var users       = [User]()
    var filterUser  = [User]()
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    var filterUserCount:Int{
        return filterUser.count
    }
    
    func fetchAllUsers() async{
        do {
            var users = try await  MockDatabaseManager.shared.fetchUsersWith()
            self.users = users
//            try await MockDatabaseManager.shared.fetchUsers()
//            var users2 = MockDatabaseManager.shared.users
            
      }catch let error{
            print(error)
        }
       
        
    }
    
    func searchUser(text:String){
        guard let currentUser = try? CurrentUserClass.returnUserID() else {return}
        
        self.filterUser = []
        self.filterUser = self.users.filter({ $0.username.contains((text))})
            .filter({ $0.userID       != currentUser })
            .sorted(by: { $0.username < $1.username })
    }
    
    func cellForRow(indexPath:Int)->User{
        let row = filterUser[indexPath]
        return row
    }
    
    func selectedUser(indexPath:Int){
        let user = filterUser[indexPath]
        coordinator?.showUserProfileAccount(user: user)
    }
    
}
extension SearchViewModel : SearchModelProtocol {
    
}

