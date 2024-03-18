//
//  PostViewModel.swift
//  DriftKit
//
//  Created by batuhan on 4.01.2024.
//

import Foundation

final class PostViewModel {
    weak var coordinator : PostViewCoordinator?
    var post        : PostModel
    
    init(coordinator: PostViewCoordinator, post: PostModel) {
        self.coordinator = coordinator
        self.post = post
    }
    
  
    func backToController(){
        coordinator?.finishedShow()
    }
    
}
