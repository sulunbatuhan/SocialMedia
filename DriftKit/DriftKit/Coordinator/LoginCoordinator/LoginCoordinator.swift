//
//  LoginCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 23.01.2024.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate :AnyObject {
    func authenticated(coordinator:LoginCoordinator)
}

final class LoginCoordinator : Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    var rootViewController            : UINavigationController
    var baseCoordinator               : BaseCoordinator?
    weak var delegate                 : LoginCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.rootViewController = navigationController
    }
    
    func start() {
        let controller       = LoginController()
        let viewModel        = LoginViewModel(coordinator: self)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func showRegisterCoordinator(){
        let coordinator = RegisterCoordinator(parentCoordinator: self, navigationController: rootViewController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showTabbarController(){
        baseCoordinator?.childDidFinish(childCoordinator: self)
        baseCoordinator?.authenticated(coordinator: self)
        
//        let tabbarCoordinator = TabbarCoordinator(navigation: rootViewController)
//        tabbarCoordinator.start()
//        self.childCoordinators.append(tabbarCoordinator)
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
