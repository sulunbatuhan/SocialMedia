//
//  CameraViewModel.swift
//  DriftKit
//
//  Created by batuhan on 5.01.2024.
//

import Foundation
import UIKit


final class CameraViewModel {
    private var coordinator : CameraCoordinator
    private var data        = [UIImage]()
    
    init(coordinator: CameraCoordinator) {
        self.coordinator = coordinator
    }
    
    func showTakenPhoto(image:UIImage){
        coordinator.startFinishController(image: image)
    }
    
    func backToHomeController(){
        coordinator.backToParentCoordinator()
    }
    
    var photosCount:Int{
        return data.count
    }
    
    func fetchPhotos(){
        Task {
            let result = await PhotoManager.shared.fetchAllPhotos()
            self.data = result
        }
    }
    
    func cellForRow(indexPath:Int)->UIImage{
        let image = data[indexPath]
        return image
    }
    
    
    func selectedImage(indexPath:Int)->UIImage{
        let image = data[indexPath]
//        showTakenPhoto(image: image)
        return image
    }
}
