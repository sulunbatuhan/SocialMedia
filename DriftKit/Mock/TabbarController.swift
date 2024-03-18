//
//  TabbarController.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home    = UINavigationController(rootViewController: HomeController())
        let search  = UINavigationController(rootViewController: SearchViewController())
        let post    = UINavigationController(rootViewController: PostShareController())
        let profile = UINavigationController(rootViewController: ProfileController())
        
        home.title     = "Home"
        search.title   = "Search"
        post.title     = "Search"
        profile.title  = "Profile"
        
        home.tabBarItem.image    = UIImage(systemName: "house")
        post.tabBarItem.image    = UIImage(systemName: "house")
        search.tabBarItem.image  = UIImage(systemName: "magnifyingglass")
        profile.tabBarItem.image = UIImage(systemName: "person")
        
        
        setViewControllers([home,search,post,profile], animated: true)
        
    }

    
}
