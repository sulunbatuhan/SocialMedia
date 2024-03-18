//
//  HomeViewModel.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import Combine
import UIKit

protocol HomeProtocol:AnyObject{
   
    func viewDidLoad()
    func viewWillAppear()
//--------------------------
    var postsCount: Int {get}
    var myStories : Int {get}
    func showMyStory()
    func cellForRow(indexPath:Int)->PostModel
    func cellForRowForStories(indexPath : Int)->StoryModel
    func openCameraForStory()
    func showDetail(indexPath : Int)
    func fetchingUsersPosts()async
    func fetchMyUserPhoto()async
    func showStoryController(storyIndex : Int)
}

final class HomeViewModel : HomeProtocol{
   
    
 
    weak var coordinator  : HomeCoordinator?
    private weak var view : HomeControllerProtocol?
    var posts             : [PostModel] = []
    var stories           : [StoryModel] = []
    var user              : User?
    
    
    init(coordinator: HomeCoordinator,view:HomeControllerProtocol) {
        self.coordinator = coordinator
        self.view = view
    }
    
    var postsCount:Int{
        return posts.count
    }
    
    
    var myStories : Int {
        return stories.count
    }
}

extension HomeViewModel {
    func showMyStory(){
        coordinator?.showStoryCoordinator(stories: stories)
    }
    
    func cellForRow(indexPath:Int)->PostModel{
        let item = posts[indexPath]
        return item
    }
    
    func cellForRowForStories(indexPath : Int)->StoryModel{
        let item = stories[0]
        return item
    }
    
    func fetchingUsersPosts()async{
//        self.posts = []
  
            do {
                try await MockDatabaseManager.shared.fetchFollowingsPosts()
                self.posts = MockDatabaseManager.shared.followingPosts
            }catch{
                
            }
        
        
        
        
        
//        DatabaseManager.shared.fetchFollowingsPosts { [weak self] posts in
//            self?.posts = []
//            self?.posts = posts
//            self?.view?.reloadData()
//        }
        
//        DatabaseManager.shared.fetchMyStories { [weak self] storyModels in
//            self?.stories = storyModels
//        }
       
    }
    
    func getUserData(userId:String)async->[PostModel]{
        self.posts = []
        do{
            let user = try await MockDatabaseManager.shared.getUserData(userId: userId)
            self.user = user
            let post =  try await MockDatabaseManager.shared.fetchFollowingsPosts()
            //            try await MockDatabaseManager.shared.fetchUsersPosts(user:user, userID: userId)
            return post
        }catch let error {
            print(error)
        }
        return []
    }

    
    
    func showDetail(indexPath : Int){
        let item = posts[indexPath]
        coordinator?.showPostDetail(post: item)
    }
    
    func didSelectForStories(indexPath : Int){
        
    }
    
    func showStoryController(storyIndex : Int){
        coordinator?.showStoryCoordinator(stories: stories )
    }
    
    func openCameraForStory(){
        coordinator?.openCameraCoordinator()
    }
    
    func fetchMyUserPhoto()  {
        Task{
            do{
                await ImageManager.shared.setImage()
//                let user = try await MockDatabaseManager.shared.getUserData(userId: CurrentUserClass.returnUserID())
               
            }catch {
                print(error)
            }
        }
    }
}

extension HomeViewModel {
    
    func viewDidLoad() {
        view?.setCollection()
        view?.refreshControl()
        fetchMyUserPhoto()
    }
    
    func viewWillAppear() {
        Task{
            await fetchingUsersPosts()
            self.posts = await getUserData(userId: try! CurrentUserClass.returnUserID())
            self.view?.reloadData()
        }
            
    }
    
    
}


