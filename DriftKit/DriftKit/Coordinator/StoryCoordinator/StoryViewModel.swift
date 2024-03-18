//
//  StoryViewModel.swift
//  DriftKit
//
//  Created by batuhan on 4.01.2024.
//

import Foundation
import UIKit
import SDWebImage

final class StoryViewModel {
    
    weak var coordinator:StoryCoordinator?
    var storyModels   : [StoryModel] = []
    var stories       = [Story]()
    
    init(coordinator: StoryCoordinator,storyModels:[StoryModel]) {
        self.coordinator = coordinator
        self.storyModels = storyModels
        self.stories = storyModels[0].stories
    }
    
    var countStories:Int{
        return stories.count
    }
    
    
    func returnImage(completion:@escaping(String)->()){
        completion(stories[0].story)
    }
    
    var imageURL : URL? {
        didSet {
            if let url = imageURL{
                imageObserver?(url)
            }
            
        }
    }
    
    var imageObserver : ((URL) -> ())?
    
    private var storyIndex : Int = 0
    
    func forward(completion:@escaping(Int)->()){
        if storyIndex < 0  || storyIndex < stories.count-1 {
            storyIndex += 1
            imageURL = URL(string: stories[storyIndex].story)
        }
        completion(storyIndex)
    }
    
    func backward(completion:@escaping(Int)->()){
        if stories.indices.contains(storyIndex - 1){
            storyIndex -= 1
            imageURL =  URL(string: stories[storyIndex].story)
        }
        completion(storyIndex)
    }
    
    
    func showNextStory(completion:@escaping(Bool,Int)->()){
        var isContain : Bool
        
        if stories.indices.contains(storyIndex){
            isContain = true
            storyIndex += 1
            //            imageURL = URL(string: stories[storyIndex].story)
        }else {
            storyIndex = 0
            isContain = false
        }
        completion(isContain,storyIndex)
    }
    
    
    
    
}
