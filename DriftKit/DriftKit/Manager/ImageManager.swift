//
//  ImageManager.swift
//  Social
//
//  Created by batuhan on 1.03.2024.
//

import Foundation
import UIKit

//ImageManager kullanıcının profil ve arkaplan fotoğrafını cacheManager üzerinden belleğe alıyor.

class ImageManager{
    static let shared = ImageManager()
    
    enum Keys:String{
        case profileImage = "profileImage"
        case backgroundImage = "backgroundImage"
    }

    func setImage() async {
        guard let currentUserID = try? CurrentUserClass.returnUserID() else {return}
        
        do{
            let userData = try await DatabaseManager.shared.getUserData(userId: currentUserID)
            if let downloadedPImage = userData.userImage, let downloadedBImage  = userData.backgroundImage {
                let profileImage    = await downloadImage(withURL: downloadedPImage)
                let backgroundImage = await downloadImage(withURL: downloadedBImage)
                
                if profileImage != nil {
                    CacheManager.shared.setImage(image: profileImage!, forKey: "profileImage")
                }
                if backgroundImage != nil {
                    CacheManager.shared.setImage(image: backgroundImage!, forKey: "backgroundImage")
                }
            }
            
        }catch let error{
            print(error)
        }
    }
    
    
    
    func downloadImage(withURL url:String) async -> UIImage?{
        guard let urlRequest = URL(string: url) else {return UIImage()}
        do{
            let data = try await URLSession.shared.data(from: urlRequest).0
            return UIImage(data: data)
        }catch let error{
            print(error)
        }
        return nil
    }
    
    //Profil fotoğrafı veya arkaplan fotoğrafını getirir.
    func getCacheForImage(forKey key : Keys ,completion:@escaping(UIImage)->()){
        if let image = CacheManager.shared.returnImageInCache(forKey: key.rawValue){
            completion(image)
        }
    }
    
}
