//
//  CacheManager.swift
//  Social
//
//  Created by batuhan on 18.02.2024.
//

import Foundation
import UIKit

final class CacheManager {
    
    static let shared = CacheManager()
    private init(){  }
    
    let cache = NSCache<NSString,UIImage>()

    func setImage(image:UIImage,forKey key:String){
        cache.setObject(image, forKey: key as NSString)
    }
    
    func returnImageInCache(forKey key : String)->UIImage?{
        return cache.object(forKey: key as NSString)
    }
    func deleteCache(forKey key : String){
        cache.removeObject(forKey: key as NSString)
    }
}
