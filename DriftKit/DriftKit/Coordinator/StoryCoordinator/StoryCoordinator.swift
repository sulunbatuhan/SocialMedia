//
//  StoryCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 4.01.2024.
//

import Foundation
import UIKit


final class StoryCoordinator : Coordinator {
    var childCoordinators    : [Coordinator] = []
    var navigationController : UINavigationController
    var parentCoordinator    : HomeCoordinator
    var storyData            : [StoryModel] = []
    
    init(parentCoordinator:HomeCoordinator,navigationController: UINavigationController,storyData : [StoryModel]) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.storyData = storyData
    }
    func start() {
        let controller = StoryController()
        let viewModel  = StoryViewModel(coordinator: self,storyModels: storyData)
        controller.viewModel = viewModel
        controller.modalPresentationStyle = .fullScreen
        navigationController.present(controller,animated: true)
    }
    
    func finished(){
        parentCoordinator.childDidFinish(childCoordinator: self)
    }
    
}
