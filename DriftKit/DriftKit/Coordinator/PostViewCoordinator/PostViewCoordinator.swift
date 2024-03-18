//
//  PostViewCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 4.01.2024.
//

import Foundation
import UIKit

final class PostViewCoordinator : Coordinator {
    var childCoordinators    : [Coordinator] = []
    var navigationController : UINavigationController
    var post                 : PostModel
    var parentCoordinator    : HomeCoordinator?
    var profileCoordinator   : ProfileCoordinator?
    
    init(navigationController: UINavigationController,post:PostModel) {
        self.navigationController = navigationController
        self.post                 =  post
    }
    
    func start() {
        let controller       = PostViewController()
        let viewModel        = PostViewModel(coordinator: self, post: self.post)
        controller.viewModel = viewModel
        navigationController.pushViewController(controller,animated: true)
    }
    
    func finishedShow(){
        parentCoordinator?.childDidFinish(childCoordinator: self)
        profileCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    deinit{
        
    }
}
