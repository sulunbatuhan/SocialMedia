//
//  MockDatabaseManager.swift
//  Social
//
//  Created by batuhan on 19.02.2024.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import UIKit
import FirebaseAuth




enum CollectionNames:String{
    case Users   = "Users"
    case Follows = "Follows"
}

class MockDatabaseManager{
    static let shared = MockDatabaseManager()
    private init() {  }
    
    private let collectionUsers  =  Firestore.firestore().collection("Users")
    
    private func userDocument(userId:String) -> DocumentReference{
        collectionUsers.document(userId)
    }
    
    private func getCollection(path:CollectionNames,userId:String) -> DocumentReference{
        Firestore.firestore().collection(path.rawValue).document(userId)
        
    }
    
    private func referenceStorageManager(withPath path:String,fileName:String)->StorageReference{
        Storage.storage().reference(withPath: "/\(path)/\(fileName)")
    }
    
    //MARK: AuthenticationManager
    
//    func isUserExist(with email:String,username:String) async throws -> Bool {
//        return false
//    }
//    
//    func createUser(withEmail email : String,password:String)async throws -> AuthDataResult {
//      return try await Auth.auth().createUser(withEmail: email, password: password)
//    }
//    
//    func insertUser(with email : String,username:String,userID :String) async throws{
//        let currentDate             = Date.now
//        let userData : [String:Any] = ["userID":userID,"username":username,"email":email,"createdDate":currentDate,"userImage":""]
//        try await userDocument(userId: userID).setData(userData)
//    }
//    
//    func ifCorrectSaveToDatabaseUser(email:String,username:String? = nil,password:String) async throws{
//    let result = try await isUserExist(with: email, username: password)
//        if result {
//            let result = try await createUser(withEmail: email, password: password)
//            try await insertUser(with: email, username: username ?? "", userID: result.user.uid)
//        }
//    }
    
 
    
    
    
    //MARK: DatabaseManager
    
    func deletePost(post:Post) async throws{
        let postId : String = post.postId
//        let query =  try await getCollection(path: .Users, userId: CurrentUserClass.returnUserID()).collection("userPosts").whereField("postId", isEqualTo: postId)

    }
    
    func getUserData(userId:String)async throws -> User{
        //        let userId           = try CurrentUserClass.returnUserID()
        let documentSnapshot = try await userDocument(userId: userId).getDocument()
        let user =  try documentSnapshot.data(as: User.self)
        print(user)
        return user
    }
    
    
    func updateProfileBackgroundPhoto(url:URL) async throws{
        let updateData = ["backgroundImage":url.absoluteString]
        try await userDocument(userId: CurrentUserClass.returnUserID()).updateData(updateData)
    }
    

    func follow(user:User)async throws{
        let userID = user.userID
        let following : [String:Bool] = [userID:true]
        let snapshot = try await getCollection(path: .Follows, userId: CurrentUserClass.returnUserID()).getDocument()
        if snapshot.exists == true {
            try await getCollection(path: .Follows, userId: CurrentUserClass.returnUserID()).updateData(following)
        }else {
            try await getCollection(path: .Follows, userId: CurrentUserClass.returnUserID()).setData(following)
        }
    }
    
    func unFollow(user:User)async throws{
        let userID = user.userID
        let deleteData = [userID:FieldValue.delete()]
        try await getCollection(path: .Follows, userId: CurrentUserClass.returnUserID()).updateData(deleteData)
    }
    
   
    
    func savePost(imageURL :URL,postId:String,text:String) async throws {
        let currentUser = try CurrentUserClass.returnUserID()
        
        let data = ["postId":postId,
                    "userID":currentUser,
                    "postImage" :imageURL.absoluteString,
                    "postText" : text,
                    "sharedDate":Date.now] as [String : Any]
        try await userDocument(userId: currentUser).collection("userPosts").addDocument(data: data)
    }
    
    
    
    func updateUserProfilePhoto(url:URL) async throws{
        let updateData = ["userImage":url.absoluteString]
        try await userDocument(userId: CurrentUserClass.returnUserID()).updateData(updateData)
    }
    
    
    func fetchUsersWith() async throws ->[User]{
        var users      = [User]()
        let documentSnapshot = try await collectionUsers.getDocuments()
        let documents  = documentSnapshot.documents
        users          = try documents.compactMap({ (snapshot) -> User in
            return try snapshot.data(as: User.self)
        })
        return users
    }
    
    func saveStoryForUser(url:URL) async throws {
        let user      = try CurrentUserClass.returnUserID()
        let storyData = ["userID"     : user,
                         "postImage"  : url.absoluteString,
                         "sharedDate" : Date.now] as [String : Any]
        try await userDocument(userId: CurrentUserClass.returnUserID()).collection("Stories").addDocument(data: storyData)
    }
    
   
    
    
    //MARK: StorageManager
//    
    func uploadPost(selectedImage : UIImage) async throws -> URL{
        let photoID = UUID().uuidString
        let photoData = selectedImage.jpegData(compressionQuality: 0.8) ?? Data()
        let reference = Storage.storage().reference(withPath: "/Posts/\(photoID)")
        let _         = try await reference.putDataAsync(photoData)
        return try await reference.downloadURL()
    }
    
    func saveStoryDatabase(file:UIImage)async throws -> URL{
        let storyMovieID = UUID().uuidString
        let uploadImage  = file.jpegData(compressionQuality: 0.8)  ?? Data()
        let ref          =  referenceStorageManager(withPath: "Stories", fileName: storyMovieID)
        let _            = try await ref.putDataAsync(uploadImage)
        return try await ref.downloadURL()
    }
    
    func saveBackgroundPictureToDatabase(image:UIImage)async throws -> URL{
        let backgroundPhotoID = UUID().uuidString
        let uploadData        = image.jpegData(compressionQuality: 0.6) ?? Data()
        let ref               = referenceStorageManager(withPath: "ProfileBackgroundPhoto", fileName: backgroundPhotoID)
        _                     = try await  ref.putDataAsync(uploadData)
        return try await ref.downloadURL()
    }
    
    
    func saveProfilePhoto(image:UIImage)async throws -> URL{
        let profilePhotoID = UUID().uuidString
        let uploadData     = image.jpegData(compressionQuality: 0.6) ?? Data()
        try await referenceStorageManager(withPath: "ProfilePhoto", fileName: profilePhotoID).putDataAsync(uploadData)
        return try await referenceStorageManager(withPath: "ProfilePhoto", fileName: profilePhotoID).downloadURL()
    }
    
    
    
    
    
//    ---------------------------------------
    

    var postModel : [PostModel] = []
    
    func fetchUsersPosts(user:User,userID:String) async throws -> [PostModel] {
        var posts     : [Post]      = []
        var postModel : [PostModel] = []
        let snapshot = try await getCollection(path: .Users, userId: userID).collection("userPosts").getDocuments()
        for document in snapshot.documents{
            let post = try document.data(as: Post.self)
            postModel.append(PostModel(user: user, post: post))
        }
        return postModel
    }
    
    
    
    var followList      : [String] = []
    
    func fetchFollowingLists(userId:String) async throws -> [String] {
        let snapshot =  try await getCollection(path: .Follows, userId: userId).getDocument()
        guard let data  =  snapshot.data() else {throw ErrorType.fetchingError}
        self.followList = data.map({ $0.key })
        return followList
    }
    
    var followingPosts  :[PostModel] = []
    
    
    func fetchFollowingsPosts() async throws -> [PostModel]{
        var postModel :[PostModel] = []
        let lists = try await fetchFollowingLists(userId: CurrentUserClass.returnUserID())
        var posts : [PostModel] = []
        for list in lists {
            let user  =  try await getUserData(userId: list)
            posts    =  try await fetchUsersPosts(user: user, userID: user.userID)
            posts.forEach { post in
                postModel.append(post)
            }
        }
        return postModel
    }
    
    
    
    var users : [User] = []
    
    func fetchUsers() async throws{
        let querySnapshot = try await collectionUsers.getDocuments()
        let documents     = querySnapshot.documents
        self.users =  documents.compactMap { try? $0.data(as: User.self) }
    }
    
}
        
        //        Firestore.firestore().collection("Follows").document(currentUser).addSnapshotListener {snapshot , error in
        //            if let error = error {
        //                return
        //            }
        //
        //            guard let data = snapshot?.data() else {return}
        //
        //            data.forEach { (key, value) in
        //                let userID : String = key
        //
        //                self.collectionUsers.document(userID).getDocument { snapshot , error in
        //                    if let error = error {
        //                        return
        //                    }
        //
        //                    let data = snapshot?.data()
        //                    let user = User(dictionary: data!)
        //                    //                        self.fetchUsersPosts(userID: userID, user: user)
        //                    self.collectionUsers.document(userID).collection("userPosts").addSnapshotListener { snapshot, error in
        //                        if let error = error{
        //                            return
        //                        }
        //
        //                        snapshot?.documentChanges.forEach({ documentChange in
        //                            if documentChange.type == .added {
        //                                let postData        = documentChange.document.data()
        //                                let veri            = Post(user:user, dictionary: postData)
        //
        //                                self.postData.append(veri)
        //                            }
        //                        })
        //                        completion(self.postData)
        //                    }
        //                }
        //
        //            }
        //        }
        //

class MockModel {
    static let shared = MockModel()
    init() {  }
    
    
    func changeProfilePicture(image:UIImage)async throws{
        let profileUrl = try await MockDatabaseManager.shared.saveProfilePhoto(image: image)
        try await MockDatabaseManager.shared.updateUserProfilePhoto(url: profileUrl)
    }
    
    
    func savePostToUserPosts(image:UIImage)async throws {
        let (url,id)  = try await StorageManager.shared.savePostToStorage(selectedImage: image)
        try await MockDatabaseManager.shared.savePost(imageURL: url, postId: id, text: "")
    }
     
    
}
