//
//  DatabaseManager.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol DatabaseManagerProtocol{
//    func isUserExist(with email:String,username:String,completion:@escaping(Bool)->Void)
//    func insertUser(with email : String,username:String,userID :String,completion:@escaping(Bool)->Void)
    
}


final class DatabaseManager : DatabaseManagerProtocol {

    static let shared = DatabaseManager()
    private init() {  }
    private var myStoryModel     = [StoryModel]()
    private var postData         = [Post]()
    private var stories          = [StoryModel]()
    private let collectionUsers  = Firestore.firestore().collection("Users")
    
    private func getCollection(path:CollectionNames,userId:String) -> DocumentReference{
        Firestore.firestore().collection(path.rawValue).document(userId)

    }
    
    private func userDocument(userId:String)->DocumentReference{
        collectionUsers.document(userId)
    }

    func getUserData(userId:String)async throws -> User{
        //        let userId           = try CurrentUserClass.returnUserID()
        let documentSnapshot = try await userDocument(userId: userId).getDocument()
        return try documentSnapshot.data(as: User.self)
    }
    
    func deletePost(post:Post) async throws{
        let postId : String = post.postId
//        let query =  try await getCollection(path: .Users, userId: CurrentUserClass.returnUserID()).collection("userPosts").whereField("postId", isEqualTo: postId)

    }
    
    func updateProfileBackgroundPhoto(image:UIImage) async throws{
        let url = try await StorageManager.shared.saveBackgroundPictureToStorage(image: image)
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
        try await userDocument(userId: CurrentUserClass.returnUserID()).collection("userPosts").addDocument(data: data)
    }
    
    func updateUserProfilePhoto(url:URL) async throws{
        let updateData = ["userImage":url.absoluteString]
        try await userDocument(userId: CurrentUserClass.returnUserID()).updateData(updateData)
    }
    
    
    func fetchUsers() async throws ->[User]{
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
    
    
    
    func fetchUsersPosts(user:User,userID:String) async throws -> [PostModel] {
        var posts :[Post] = []
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
    
    var postModel : [PostModel] = []
    
    
    func fetchFollowingsPosts() async throws -> [PostModel] {
        var postModel : [PostModel] = []
        let lists = try await fetchFollowingLists(userId: CurrentUserClass.returnUserID())
        for list in lists {
            let user  =  try await getUserData(userId: list)
            let posts =  try await fetchUsersPosts(user: user, userID: user.userID)
            posts.forEach { posts in
                postModel.append(posts)
            }
        }
        return postModel
    }
    
    
    
    
    var users      : [User]       = []
    var storyModel : [StoryModel] = []
    
    func fetchUsers() async throws{
        let querySnapshot = try await collectionUsers.getDocuments()
        let documents     = querySnapshot.documents
        self.users =  documents.compactMap { try? $0.data(as: User.self) }
    }
    
    func fetchMyStories()async throws ->[StoryModel]{
        var myStory : [StoryModel] = []
        guard let currentUserId = try? CurrentUserClass.returnUserID() else {throw ErrorType.fetchingError}
        let user                = try await getUserData(userId: currentUserId)
        let querySnapshot = try await getCollection(path: .Users, userId: currentUserId).collection("Stories").getDocuments()
        let documents = querySnapshot.documents
        
        let stories = documents.compactMap { snapshot in
            return try? snapshot.data(as: Story.self)
        }
        stories.forEach { story in
//            myStory.append(StoryModel(user: user, stories: sto))
        }
        return myStory
    }
    
    
    
//    
//    func isUserExist(with email:String,username:String,completion:@escaping(Bool)->Void){
//        //        Firestore.firestore().collection("users").addSnapshotListener { snapshot , error in
//        //            if let error = error {
//        //
//        //            }
//        //            let dataSnapshot = snapshot?.documents
//        //
//        //        }
//        
//        completion(false)
//    }
    //yapıldı
    
//    func insertUser(with email : String,username:String,userID :String,completion:@escaping(Bool)->Void){
//        let currentDate = Date.now
//        DispatchQueue.main.async {
//            Firestore.firestore().collection("Users").document(userID).setData(["userID":userID,"username":username,"email":email,"createdDate":currentDate,"userImage":""]) { error in
//                guard error == nil else {
//                    return completion(false)
//                }
//                return completion(true)
//            }
//        }
//    }
    //yapıldı
//    func fetchUsers(completion:@escaping([User])->()){
//        var users = [User]()
//        DispatchQueue.main.async {
//            Firestore.firestore().collection("Users").getDocuments { snapshot, error in
//                if error != nil {
//                    return
//                }
//                snapshot?.documentChanges.forEach({ changed in
//                    if changed.type == .added {
//                        let user = User(dictionary: changed.document.data())
//                        if user.userID != Auth.auth().currentUser?.uid {
//                            users.append(user)
//                        }
//                    }
//                })
//                completion(users)
//            }
//        }
//    }
    //yapıldı
    
//    func getCurrentUserData(completion:@escaping(User)->()){
//        guard let userId = Auth.auth().currentUser?.uid else {return}
//        
//        Firestore.firestore().collection("Users").document(userId).getDocument { snapshot , error in
//            if let error = error {
//                return
//            }
//            let data = snapshot?.data()
//            let user = User(dictionary: data!)
//            completion(user)
//        }
//    }
    
//    yapıldı
//    func follow(user:User,completion:@escaping(Bool)->()){
//        let userID = user.userID
//        let following : [String:Bool] = [userID:true]
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//        
//        Firestore.firestore().collection("Follows").document(currentUser).getDocument {[weak self] snapshot , error in
//            if let error = error {
//                completion(false)
//                return
//            }
//            if snapshot?.exists == true {
//                
//                Firestore.firestore().collection("Follows").document(currentUser).updateData(following) { error in
//                    if let error = error {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }else {
//                Firestore.firestore().collection("Follows").document(currentUser).setData(following){ error in
//                    if let error = error {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }
//        }
//    }
//    yapıldı
//    func unFollow(user:User,completion:@escaping(Bool)->()){
//        let userID = user.userID
//        
//        guard  let currentUser = Auth.auth().currentUser?.uid else {return}
//        Firestore.firestore().collection("Follows").document(currentUser).updateData([userID:FieldValue.delete()]) { error in
//            if let error = error {
//                completion(false)
//                return
//            }
//            completion(true)
//            
//        }
//    }
   
//    func fetchMyStories(completion: @escaping([StoryModel])->()){
//        
//        let referenceUser     =  Firestore.firestore().collection("Users")
//        
//        guard let currentID   = Auth.auth().currentUser?.uid else {return }
//        
//        DispatchQueue.global().async {
//            referenceUser.document(currentID).getDocument {  snapshot , error in
//                if let error = error {
//                    return
//                }
//                
//                let data = snapshot?.data()
//                let user = User(dictionary: data!)
//                
//                referenceUser.document(currentID).collection("Stories").addSnapshotListener { snapshot, error in
//                    if error != nil {
//                        return
//                    }
//                    var myStories = [Story]()
//                    
//                    snapshot?.documentChanges.forEach({ change in
//                        if change.type == .added {
//                            let storyData  = change.document.data()
//                            
//                            let story = Story(user: user,dictionary: storyData)
//                            
//                            myStories.append(story)
//                            
//                        }
//                    })
//                    
//                    self.myStoryModel.append(StoryModel(user: user, stories: myStories))
//                }
//                completion(self.myStoryModel)
//            }
//        }
//    }
    
//    func fetchFollowingsPosts(completion:@escaping([Post])->()) {
//        postData.removeAll()
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//
//        DispatchQueue.main.async {
//            Firestore.firestore().collection("Follows").document(currentUser).addSnapshotListener {snapshot , error in
//                if let error = error {
//                    return
//                }
//                
//                guard let data = snapshot?.data() else {return}
//                data.forEach { (key, value) in
//                    let userID : String = key
//                    
//                    self.collectionUsers.document(userID).getDocument { snapshot , error in
//                        if let error = error {
//                            return
//                        }
//                        
//                        let data = snapshot?.data()
//                        let user = User(dictionary: data!)
//                        
//                        
//                        //                        self.fetchUsersPosts(userID: userID, user: user)
//                        self.collectionUsers.document(userID).collection("userPosts").addSnapshotListener { snapshot, error in
//                            if let error = error{
//                                return
//                            }
//                            snapshot?.documentChanges.forEach({ documentChange in
//                                if documentChange.type == .added {
//                                    let postData        = documentChange.document.data()
//                                    let veri            = Post(user:user, dictionary: postData)
//                                  
//                                    self.postData.append(veri)
//                                }
//                            })
//                            completion(self.postData)
//                        }
//                    }
//                    
//                }
//            }
//        }
//    }
    
//    private func fetchUsersPosts(userID:String,user:User){
//        
//        collectionUsers.document(userID).collection("userPosts").addSnapshotListener { snapshot, error in
//            if let error = error{
//                return
//            }
//            snapshot?.documentChanges.forEach({ documentChange in
//                if documentChange.type == .added {
//                    let postData        = documentChange.document.data()
//                    let veri            = Post(user:user, dictionary: postData)
//                    self.postData.append(veri)
//                }
//            })
//        }
//    }
    
//    private func fetchUserStories(completion:@escaping([StoryModel])->()){
//        
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//        
//        DispatchQueue.main.async {
//            Firestore.firestore().collection("Follows").document(currentUser).addSnapshotListener {snapshot , error in
//                if let error = error {
//                    return
//                }
//                
//                guard let data = snapshot?.data() else {return}
//                data.forEach { (key, value) in
//                    
//                    let userID : String = key
//                    
//                    self.collectionUsers.document(userID).getDocument { snapshot , error in
//                        if let error = error {
//                            return
//                        }
//                        
//                        let data = snapshot?.data()
//                        let user = User(dictionary: data!)
//                        
//                        self.collectionUsers.document(currentUser).collection("Stories").addSnapshotListener { snapshot, error in
//                            if error != nil {
//                                return
//                            }
//                            var myStories = [Story]()
//                            
//                            snapshot?.documentChanges.forEach({ change in
//                                if change.type == .added {
//                                    let storyData  = change.document.data()
//                                    
//                                    let story = Story(user: user,dictionary: storyData)
//                                    
//                                    myStories.append(story)
//                                    
//                                }
//                            })
//                            
//                            self.myStoryModel.append(StoryModel(user: user, stories: myStories))
//                        }
//                        completion(self.myStoryModel)
//                    }
//                }
//            }
//        }
//    }
    

    
    
    

    
    
    
    
    
    
}





