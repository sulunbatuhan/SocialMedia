//
//  SearchCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit

final class SearchCoordinator : Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let rootViewController               = UINavigationController()
  
    func start() {
        let controller       = SearchViewController()
        let viewModel        = SearchViewModel(coordinator: self)
        controller.viewModel = viewModel
        rootViewController.setViewControllers([controller], animated: true)
    }
    
    func showUserProfileAccount(user:User){
        let profileCoordinator               = ProfileCoordinator(navigationController: rootViewController)
        profileCoordinator.coordinator = self
        profileCoordinator.user              = user
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)
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

