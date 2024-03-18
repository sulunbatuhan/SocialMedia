//
//  ShareCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit

final class ShareCoordinator : Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let rootViewController               = UINavigationController()
  
    func start() {
        let controller       = PostShareController()
        let viewModel        = ShareViewModel(coordinator: self,view: controller)
        controller.viewModel = viewModel
        rootViewController.setViewControllers([controller], animated: true)
    }
    
    func moveToShare(post:Post){
        
    }
    
}
