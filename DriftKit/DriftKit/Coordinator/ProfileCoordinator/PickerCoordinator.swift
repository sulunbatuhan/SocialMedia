//
//  PickerCoordinator.swift
//  DriftKit
//
//  Created by batuhan on 3.01.2024.
//

import Foundation
import PhotosUI

final class PickerCoordinator : NSObject,Coordinator {
    var childCoordinators    : [Coordinator] = []
    
    var parentCoordinator    : ProfileCoordinator
    var navigationController : UINavigationController
    var imageObs             : ((UIImage?)->())?
    
    init(parentCoordinator: ProfileCoordinator, navigationController: UINavigationController) {
        self.parentCoordinator    = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        var config                = PHPickerConfiguration()
        config.filter             = .images
        config.selectionLimit     = 1
        let pickerController      = PHPickerViewController(configuration: config)
        pickerController.delegate = self
        navigationController.pushViewController(pickerController, animated: true)
    }
   
    func didFinish(image:UIImage){
        imageObs?(image)
        parentCoordinator.childDidFinish(childCoordinator: self)
    }
}

extension PickerCoordinator : UINavigationControllerDelegate,PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
//                StorageManager.shared.uploadProfilePicture(image: image)
                DispatchQueue.main.async {
                    self?.didFinish(image: image)
                }
            }
        }
    }
}
