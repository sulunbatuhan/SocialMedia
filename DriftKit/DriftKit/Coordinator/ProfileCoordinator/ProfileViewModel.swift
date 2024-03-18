//
//  ProfileViewModel.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import FirebaseAuth
import UIKit

protocol ProfileViewModelProtocol{
    func viewDidLoad()
    func viewWillAppear()
//    *********************
    var photosCount:Int{get}
    func didSelect(indexPath:Int)
    func cellForRow(indexPath:Int)->PostModel
    func changeProfilePhoto()async
    func changeBackgroundPhoto()
    func loadPhoto()async
    func singOut() throws
    func getUserData(userId:String)async->[PostModel]
}

final class ProfileViewModel {
   
    weak var coordinator : ProfileCoordinator?
    weak var view        : ProfileControllerProtocol?
    var posts            = [PostModel]()
    var user             : User?
    var storageManager   = StorageManager.shared
  
    init(coordinator: ProfileCoordinator,user:User? = nil,view:ProfileControllerProtocol) {
        self.coordinator = coordinator
        self.user        = user
        self.view = view
    }
    
    var photosCount:Int{
        return posts.count
    }
   
    
}
extension ProfileViewModel {
    
    func didSelect(indexPath:Int){
        let row = posts[indexPath]
        coordinator?.showPostDetail(post: row)
    }
    
    func cellForRow(indexPath:Int)->PostModel{
        let item = posts[indexPath]
        return item
    }
    
    fileprivate func handleProfilePhoto(_ profileImage: UIImage?) {
        Task{
            do{
                try await MockModel.shared.changeProfilePicture(image: profileImage!)
                await ImageManager.shared.setImage()
            }catch let error{
                print(error)
            }
        }
    }
    
    func changeProfilePhoto() {
        coordinator?.startPickerCoordinator(completion: { [weak self] profileImage in
            if profileImage != nil {
                self?.handleProfilePhoto(profileImage)
            }
        })
    }

    func changeBackgroundPhoto(){
        coordinator?.startPickerCoordinator(completion: { [weak self] backgroundImage in
            if backgroundImage != nil{
                Task{
                    do{
                        try await DatabaseManager.shared.updateProfileBackgroundPhoto(image: backgroundImage!)
                    }catch{
                        
                    }
                }
            }
        })
    }
    
    func getUserData(userId:String)async->[PostModel]{
        
        do{
            let user = try await MockDatabaseManager.shared.getUserData(userId: userId)
            self.user = user
            let post = try await MockDatabaseManager.shared.fetchUsersPosts(user:user, userID: userId)
            return post
        }catch let error {
            print(error)
        }
        
        return []
    }
    
    
    func loadPhoto() {
        Task{
            guard let currentUserId = try? CurrentUserClass.returnUserID() else {return}
            if self.user?.userID == nil{
                self.posts = await getUserData(userId: currentUserId)
            }else {
                guard let userID  = self.user?.userID else {return}
                self.posts = await  getUserData(userId: userID)
            }
        }
    }

    func singOut() throws{
        do {
            try AuthenticationManager.shared.signOut()
            coordinator?.logOut()
        }catch{
            print("çıkış yapılamadı")
        }
    }
}

//MARK: UI Stuff
extension ProfileViewModel:ProfileViewModelProtocol {
   
    func viewDidLoad() {
        view?.setCollection()
        view?.refreshControl()
        view?.setNavigation()
        
    }
    
    func viewWillAppear()  {
        loadPhoto()
        view?.reloadData()
    }
    
    
}
