//
//  HomeCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit

final class HomeCoordinator : Coordinator {
   
    var childCoordinators: [Coordinator] = []
    let rootViewController               =   UINavigationController()
    
    
    func start() {
        let controller       = HomeController()
        let viewModel        = HomeViewModel(coordinator: self,view: controller)
        controller.viewModel = viewModel
        rootViewController.setViewControllers([controller], animated: true)
        
    }
    func showUserProfileAccount(user:User){
        let profileCoordinator               = ProfileCoordinator(navigationController: rootViewController)
        profileCoordinator.coordinator = self
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)
    }
    
    func showPostDetail(post:PostModel){
        let detailCoordinator = PostViewCoordinator(navigationController: rootViewController, post: post)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func showStoryCoordinator(stories : [StoryModel]){
        let storyCoordinator = StoryCoordinator(parentCoordinator: self, navigationController: rootViewController,storyData: stories)
        childCoordinators.append(storyCoordinator)
        storyCoordinator.start()
    }
    
    func openCameraCoordinator(){
        let cameraCoordinator = CameraCoordinator(navigationController: rootViewController)
        cameraCoordinator.parentCoordinator = self
        childCoordinators.append(cameraCoordinator)
        cameraCoordinator.start()
    }
    
    

    func childDidFinish(childCoordinator:Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
            self.rootViewController.popViewController(animated: true)
            self.rootViewController.dismiss(animated: true)
        }
    }
    
}
