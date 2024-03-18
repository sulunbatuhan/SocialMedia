//
//  PhotoManager.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import Foundation
import Photos
import AVFoundation
import UIKit
import Combine

final class PhotoManager {
    
    static let shared = PhotoManager()
    private init(){  }
    let library       = PHPhotoLibrary.shared()
    let fetchOptions  = PHFetchOptions()
    var photos        = [UIImage]()
 
    func fetchAllPhotos()  -> [UIImage] {
        photos                       = []
        let sort                     = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchOptions.sortDescriptors = [sort]
//        fetchOptions.fetchLimit      =
        let photo                    = PHAsset.fetchAssets(with: fetchOptions)
        photo.enumerateObjects { asset, index , stopPoint in
            let imageManager      = PHImageManager.default()
            let photoSize         = CGSize(width: 1000, height: 1000)
            let options           = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: photoSize, contentMode: .aspectFill, options: options) { image, imageInfo in
                if let photo = image {
                    self.photos.append(photo)
                }
            }
        }
        return photos
    }
}
