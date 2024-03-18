//
//  ShareViewModel.swift
//  DriftKit
//
//  Created by batuhan on 30.12.2023.
//

import Foundation
import UIKit

protocol ShareViewModelProtocol{
    func viewDidLoad()
    func viewWillAppear()
}

final class ShareViewModel {
    private weak var coordinator  : ShareCoordinator?
    private weak var view         : PostShareControllerProtocol?
    private var selectedImage: UIImage?
    private var data = [UIImage]()
    
    init(coordinator : ShareCoordinator,view:PostShareControllerProtocol) {
        self.coordinator = coordinator
        self.view = view
    }
    
    var photosCount:Int{
        return data.count
    }
    
    func fetchPhotos(){
        let result = PhotoManager.shared.fetchAllPhotos()
        self.data = result
      
    }
    
    func cellForRow(indexPath:Int)->UIImage{
        let image = data[indexPath]
        return image
    }
    
    
    func selectedImage(indexPath:Int)->UIImage{
        let image = data[indexPath]
        self.selectedImage = image
        return image
    }
}

//MARK: UI Stuff
extension ShareViewModel : ShareViewModelProtocol{
    
    func viewDidLoad() {
        view?.setCollection()
        view?.setNavigation()
        fetchPhotos()
        view?.reloadData()
        view?.headerImage = data.last
    }
    
    func viewWillAppear() {
        view?.reloadData()
    }
}
