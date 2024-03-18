//
//  StorageManager.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import Foundation
import FirebaseStorage
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Combine

enum PostType {
    case video,photo
}


protocol StorageManagerProtocol {
    func uploadPost(selectedImage : UIImage,text:String,completion:@escaping(Bool)->())
    func savePost(imageURL :String,text:String)
    func uploadProfilePicture(image:UIImage)
    func fetchPhotos(user:String,completion:@escaping([Post])->())
    
}

final class StorageManager {
    
    static let shared = StorageManager()
    private init(){  }
    
    private func referenceStorageManager(withPath:String,fileName:String)->StorageReference{
        Storage.storage().reference(withPath: "/\(withPath)/\(fileName)")
    }

    func savePostToStorage(selectedImage : UIImage) async throws -> (URL,String){
        let photoID = UUID().uuidString
        let photoData = selectedImage.jpegData(compressionQuality: 0.8) ?? Data()
        let reference = Storage.storage().reference(withPath: "/Posts/\(photoID)")
        let _         = try await reference.putDataAsync(photoData)
        return (try await reference.downloadURL(),photoID)
    }
    
    func saveStoryToStorage(file:UIImage)async throws -> URL{
        let storyMovieID = UUID().uuidString
        let uploadImage  = file.jpegData(compressionQuality: 0.8)  ?? Data()
        let ref          =  referenceStorageManager(withPath: "Stories", fileName: storyMovieID)
        let _            = try await ref.putDataAsync(uploadImage)
        return try await ref.downloadURL()
    }
    
    func saveBackgroundPictureToStorage(image:UIImage)async throws -> URL{
        let backgroundPhotoID = UUID().uuidString
        let uploadData        = image.jpegData(compressionQuality: 0.6) ?? Data()
        let ref               = referenceStorageManager(withPath: "ProfileBackgroundPhoto", fileName: backgroundPhotoID)
        _                     = try await  ref.putDataAsync(uploadData)
        return try await ref.downloadURL()
    }
    
    func saveProfilePhotoToStorage(image:UIImage)async throws -> URL{
        let profilePhotoID = UUID().uuidString
        let uploadData     = image.jpegData(compressionQuality: 0.6) ?? Data()
        try await referenceStorageManager(withPath: "ProfilePhoto", fileName: profilePhotoID).putDataAsync(uploadData)
        return try await referenceStorageManager(withPath: "ProfilePhoto", fileName: profilePhotoID).downloadURL()
    }
    
    func deletePost(post:Post){
        let postUserID : String = post.postId
        //        guard let userID == CurrentUserClass.returnUserID() else {return}
        Firestore.firestore().collection("Users").document().collection("userPosts").whereField("postId", isEqualTo: postUserID)
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //yapıldı
//    func uploadPost(selectedImage : UIImage,text:String,completion:@escaping(Bool)->()){
//        let photoID = UUID().uuidString
//        let photo = selectedImage.jpegData(compressionQuality: 0.8) ?? Data()
//        let reference = Storage.storage().reference(withPath: "/Posts/\(photoID)")
//        
//        reference.putData(photo) { _, error in
//            guard error == nil else {return completion(false) }
//            reference.downloadURL { url, error in
//                self.savePost(imageURL: url?.absoluteString ?? "", text: text)
//            }
//            completion(true)
//        }
//    }
//    //yapıldı
//    func savePost(imageURL :String,text:String){
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//        
//        let data = ["userID":currentUser,
//                    "postImage" :imageURL,
//                    "postText" : text,
//                    "sharedDate":Date.now] as [String : Any]
//        
//        Firestore.firestore().collection("Users").document(currentUser).collection("userPosts").addDocument(data: data) { error in
//            if let error = error {
//                print("hata")
//            }else {
//                print("başarılı")
//            }
//        }
//    }
    
    
    
    
//    Yapıldı
//    func uploadProfilePicture(image:UIImage){
//        guard let userID = Auth.auth().currentUser?.uid else {return}
//        let profilePhotoID = UUID().uuidString
//        
//        let uploadData = image.jpegData(compressionQuality: 0.6) ?? Data()
//        
//        let reference = Storage.storage().reference(withPath: "/ProfilePhoto/\(profilePhotoID)")
//        reference.putData(uploadData){ _, error in
//            if let error = error {
//                return
//            }
//            reference.downloadURL { url, error in
//                Firestore.firestore().collection("Users").document(userID).updateData(["userImage":url?.absoluteString ?? "" ]) { error in
//                    if let error = error{
//                        return
//                    }
//                }
//            }
//        }
//    }
//    
//    yapıldı
//    func uploadBackgroundPicture(image:UIImage){
//        guard let userID      = Auth.auth().currentUser?.uid else {return}
//        let backgroundPhotoID = UUID().uuidString
//        
//        let uploadData = image.jpegData(compressionQuality: 0.6) ?? Data()
//        
//        let reference = Storage.storage().reference(withPath: "/ProfileBackgroundPhoto/\(backgroundPhotoID)")
//        reference.putData(uploadData){ _, error in
//            if let error = error {
//                return
//            }
//            reference.downloadURL { url, error in
//                Firestore.firestore().collection("Users").document(userID).updateData(["backgroundImage":url?.absoluteString ?? "" ]) { error in
//                    if let error = error{
//                        return
//                    }
//                }
//            }
//        }
//    }
    
//    Daha sonra 
    
    
//    func fetchPhotos(user:String,completion:@escaping([Post])->()){
//        guard let userID = Auth.auth().currentUser?.uid else {return}
//        data = []
//        let referenceCollection =  Firestore.firestore().collection("Users").document(user)
//        
//        referenceCollection.getDocument { snapshot , error in
//            if let error = error {
//                return
//            }
//            
//            let data = snapshot?.data()
//            let user = User(dictionary: data!)
//            
//            referenceCollection.collection("userPosts").addSnapshotListener { snapshot, error in
//                if let error = error{
//                    return
//                }
//                snapshot?.documentChanges.forEach({ documentChange in
//                    
//                    if documentChange.type == .added {
//                        let postData = documentChange.document.data()
//                    
//                        let veri = Post(user:user,dictionary: postData)
//                        self.data.append(veri)
//                    }
//                })
//                completion(self.data)
//            }
//        }
//    }
    
    
    
    
    
    
    
//    func uploadStory(file:UIImage,completion: @escaping (Bool)->()){
//        
//        guard let userID = Auth.auth().currentUser?.uid else {return}
//        let storyMovieID = UUID().uuidString
//        let ref = Storage.storage().reference(withPath: "/Stories/\(storyMovieID)")
//        
//        let uploadImage = file.jpegData(compressionQuality: 0.8)  ?? Data()
//    
//        ref.putData(uploadImage) { _, error in
//            if error != nil {
//                completion(false)
//            }
//            ref.downloadURL { url, error in
//                
//                let data = ["userID":userID,
//                            "postImage": url?.absoluteString,
//                            "sharedDate":Date.now] as [String : Any]
//                
//                Firestore.firestore().collection("Users").document(userID).collection("Stories").addDocument(data: data) { error in
//                    if error != nil {
//                        completion(false)
//                    }
//                    completion(true)
//                }
//            }
//        }
//    }
//    


