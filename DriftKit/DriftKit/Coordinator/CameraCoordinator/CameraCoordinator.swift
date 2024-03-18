//
//  CameraCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 5.01.2024.
//

import Foundation
import UIKit


final class CameraCoordinator : Coordinator {
    
    var childCoordinators    : [Coordinator] = []
    var navigationController : UINavigationController
    var parentCoordinator    : HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller       = CameraController()
        let viewModel        = CameraViewModel(coordinator: self)
        controller.viewModel = viewModel
        controller.modalPresentationStyle = .fullScreen
        navigationController.present(controller, animated: true)
    }
    
    func startFinishController(image:UIImage){
//       let finish = FinishCoordinator(navigationController: navigationController,parentCoordinator: self,image: image)
//        childCoordinators.append(finish)
//        finish.start()
    }
    
    func backToParentCoordinator(){
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
}

final class FinishCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var parentCoordinator : CameraCoordinator?
    var image : UIImage?
    var navigationController : UINavigationController
    
    init(navigationController:UINavigationController,parentCoordinator : CameraCoordinator,image:UIImage){
        self.parentCoordinator = parentCoordinator
        self.image = image
        self.navigationController = navigationController
    }
    
    func start() {
        let controller       = FinishPhotoController()
        controller.image = image
        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
    }
}
