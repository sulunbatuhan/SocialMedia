//
//  TabbarCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit

protocol TabbarCoordinatorDelegate : AnyObject {
    func logOut(coordinator:TabbarCoordinator)
}

final class TabbarCoordinator : Coordinator{
    
    var childCoordinators    : [Coordinator] = []
    var parentCoordinator    : BaseCoordinator?
    
    let tabbarController     = UITabBarController()
    
    weak var delegate        : TabbarCoordinatorDelegate?
    
    var navigationController : UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func logOut(){
        parentCoordinator?.childDidFinish(childCoordinator: self)
        parentCoordinator?.logOut(coordinator: self)
    }
    
    func start() {
            let homeCoordinator = HomeCoordinator()
            homeCoordinator.start()
            self.childCoordinators.append(homeCoordinator)
            let homeController = homeCoordinator.rootViewController
            setCoordinators(controller: homeController, title: "House", barItem: "house")
            
            let shareCoordinator =  ShareCoordinator()
            shareCoordinator.start()
            self.childCoordinators.append(shareCoordinator)
            let shareController = shareCoordinator.rootViewController
            setCoordinators(controller: shareController, title: "Share", barItem: "photo.badge.plus.fill")
            
            let searchCoordinator =  SearchCoordinator()
            searchCoordinator.start()
            self.childCoordinators.append(searchCoordinator)
            let searchController = searchCoordinator.rootViewController
            setCoordinators(controller: searchController, title: "Search", barItem: "magnifyingglass")
            
            
            let profileCoordinator =  ProfileCoordinator(navigationController: UINavigationController())
            profileCoordinator.parentCoordinator = self
            profileCoordinator.start()
            self.childCoordinators.append(profileCoordinator)
            let profileController = profileCoordinator.rootViewController
            setCoordinators(controller: profileController, title: "Profile", barItem: "person")
            
            self.tabbarController.viewControllers = [homeController,searchController,shareController,profileController]
            tabbarController.show(tabbarController, sender: nil)
        
    }
    
    func setCoordinators(controller:UIViewController,title:String,barItem:String){
        let image =  UIImage(systemName: barItem)
        let tabbarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        controller.tabBarItem = tabbarItem
    }
    
    
    func childDidFinish(childCoordinator:Coordinator){
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
//            self.navigationController.popViewController(animated: true)
        }
    }
    
  
}

