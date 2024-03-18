//
//  BaseCoordinator.swift
//  Social
//
//  Created by batuhan on 15.02.2024.
//

import Foundation
import UIKit

class BaseCoordinator: NSObject, Coordinator {
    
    var childCoordinators  = [Coordinator]()
    private let window     : UIWindow
    var rootViewController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    var isLoggedIn : Bool = AuthenticationManager.shared.checkUserAuth()
   
    func start() {
        print(isLoggedIn)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        if isLoggedIn {
            tabbarCoordinator()
        }else{
            loginCoordinator()
        }
    }
    
    func loginCoordinator(){
        let loginCoordinator             = LoginCoordinator(navigationController: rootViewController)
        loginCoordinator.start()
        loginCoordinator.baseCoordinator = self
        loginCoordinator.delegate        = self
        self.childCoordinators.append(loginCoordinator)
        window.rootViewController        = loginCoordinator.rootViewController
        window.makeKeyAndVisible()
    }
    
    func tabbarCoordinator(){
        let tabbarCoordinator               = TabbarCoordinator(navigationController: rootViewController)
        tabbarCoordinator.start()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.delegate          = self
        self.childCoordinators.append(tabbarCoordinator)
        window.rootViewController           = tabbarCoordinator.tabbarController
        window.makeKeyAndVisible()
    }
    
    
    
    func childDidFinish(childCoordinator:Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
            self.rootViewController.popToRootViewController(animated: true)
        }
    }
    
    
}

extension BaseCoordinator : LoginCoordinatorDelegate {
    func authenticated(coordinator:LoginCoordinator) {
        tabbarCoordinator()
    }
}

extension BaseCoordinator : TabbarCoordinatorDelegate {
    func logOut(coordinator : TabbarCoordinator) {
        loginCoordinator()
    }
}

extension BaseCoordinator : UINavigationControllerDelegate {
   
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let loginViewController = fromViewController as? LoginController {
            self.childDidFinish(childCoordinator: (loginViewController.viewModel?.coordinator)!)
        }

        if let tabbarController = fromViewController as? TabbarCoordinator {
            childDidFinish(childCoordinator: tabbarController)
        }
    }
}
