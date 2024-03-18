//
//  ProfileCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit
import PhotosUI


final class ProfileCoordinator : Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var coordinator                 : Coordinator?
    weak var parentCoordinator           : TabbarCoordinator?
    let rootViewController               = UINavigationController()
    var user                             : User?
    var navigationController             : UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller       = ProfileController()
        let viewModel        = ProfileViewModel(coordinator: self,user: self.user,view: controller)
        controller.viewModel = viewModel
        if user != nil {
            controller.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(controller, animated: true)
        }else{
            rootViewController.setViewControllers([controller], animated: true)
        }
    }
    func logOut(){
        parentCoordinator?.logOut()
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    func showPostDetail(post:PostModel){
        let detailCoordinator = PostViewCoordinator(navigationController: rootViewController, post: post)
        detailCoordinator.profileCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
   
    func startPickerCoordinator(completion: @escaping (UIImage?)->(Void)){
        let picker = PickerCoordinator(parentCoordinator: self, navigationController: rootViewController)
        childCoordinators.append(picker)
        picker.start()
        picker.imageObs = { [weak self] imageURL in
            completion(imageURL)
        }
    }
    
    func childDidFinish(childCoordinator:Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
            self.rootViewController.popViewController(animated: true)
        }
    }
}

