//
//  RegisterCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 23.01.2024.
//

import Foundation
import UIKit

final class RegisterCoordinator : Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator                : LoginCoordinator
    var navigationController             : UINavigationController
    
    init(parentCoordinator: LoginCoordinator, navigationController: UINavigationController) {
        self.parentCoordinator    = parentCoordinator
        self.navigationController = navigationController
    }
    
    
    func start() {
        let controller       = RegisterController()
        let viewModel        = RegisterViewModel(coordinator: self)
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    
    func backLoginCoordinator(){
        parentCoordinator.childDidFinish(childCoordinator: self)
    }
    
}
