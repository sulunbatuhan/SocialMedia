//
//  ShareController.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import UIKit
import SnapKit

class ShareController: UIViewController {

    var selectedImage : UIImage? {
        didSet{
            postImage.image = selectedImage
        }
    }
    
    private let userImage : UIImageView = {
        let imageView                = UIImageView()
        imageView.contentMode        = .scaleAspectFill
        imageView.clipsToBounds      = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let userName:UILabel = {
        let label           = UILabel()
        label.font          = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let dotButton:UIButton = {
        let button       = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let postText : UITextView = {
        let textView  = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return textView
    }()
    
    private let postImage : UIImageView = {
        let imageView                = UIImageView()
        imageView.contentMode        = .scaleAspectFill
        imageView.clipsToBounds      = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor              = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gönder", style: .done, target: self, action: #selector(uploadPost))
        setCurrentUserStuff()
    }
    
    func setCurrentUserStuff(){
        guard let currentUserID = try? CurrentUserClass.returnUserID() else {return}
        Task{
            let user       = try await DatabaseManager.shared.getUserData(userId: currentUserID)
            userName.text = user.username
        }
        
        ImageManager.shared.getCacheForImage(forKey: .profileImage) { [weak self] image in
            self?.userImage.image = image
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    @objc private func uploadPost(){
        let text = postText.text
        Task{
            do {
//                let url = try await StorageManager.shared.savePostToStorage(selectedImage: selectedImage ?? UIImage())
//                try await MockDatabaseManager.shared.savePost(imageURL: url.absoluteString, text: text ?? "")
                try await MockModel.shared.savePostToUserPosts(image: selectedImage ?? UIImage())
            }catch {
             fatalError("uploadPostError")
            }
        }
      
        self.navigationController?.popViewController(animated: true)
        
        
//        StorageManager.shared.uploadPost(selectedImage: self.selectedImage ?? UIImage(),text: text ?? "") { success in
//            if success {
//                self.showAlert(message: "Başarıyla yüklendi")
//               
//            }else {
//                self.showAlert(message: "Yüklemedi")
//            }
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    
    
    private func setLayout(){
        view.addSubviews(userImage,userName,dotButton,postText,postImage)
        userImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(4)
            make.left.equalTo(view).offset(12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(4)
            make.left.equalTo(userImage.snp_rightMargin).offset(12)
            make.right.equalTo(dotButton.snp_leftMargin).offset(-12)
            make.height.equalTo(40)
        }
        
        dotButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(4)
            make.left.equalTo(userName.snp_rightMargin).offset(12)
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(40)
            
        }
        
        postText.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(10)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(50)
        }
        postImage.snp.makeConstraints { make in
            make.top.equalTo(postText.snp.bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(view).multipliedBy(0.5)
        }
    }
   

}
