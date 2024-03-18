//
//  ProfileHeaderView.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit
import SnapKit
import FirebaseAuth


protocol ProfileHeaderProtocol{
    func didTapGridButton()
    func didTapListButton()
    func didTapImageButton()
    func didTapBackgroundImageTapped()
}

class ProfileHeaderView: UICollectionReusableView {
       
    static let reuseIdentifier = "profileHeaderView"
    var delegate               : ProfileHeaderProtocol?
    var tapped                 : Bool = false
    
    var userHeader             : User?{
        didSet{
            guard let currentUserID = try? CurrentUserClass.returnUserID() else {return}
            setHeader(user: userHeader)
            self.username.text = userHeader?.username
            
            if userHeader?.userID != currentUserID{
                if let backgroundImageURL = URL(string: userHeader?.backgroundImage ?? ""){
                    backgroundImage.sd_setImage(with: backgroundImageURL)
                }
                if let profileImageURL = URL(string: userHeader?.userImage ?? ""){
                    userImage.sd_setImage(with: profileImageURL)
                }else{
                    userImage.image = UIImage(named: "noneUser")
                }
            }else{
                ImageManager.shared.getCacheForImage(forKey: .profileImage) { [weak self] image in
                    self?.userImage.image = image
                }
                ImageManager.shared.getCacheForImage(forKey: .backgroundImage) { [weak self] image in
                    self?.backgroundImage.image = image
                }
            }
            if let about = userHeader?.aboutYou {
                aboutYou.text = about
            }
        }
    }
    
    
    
    func setHeader(user:User?){
        guard let currentUserId = try? CurrentUserClass.returnUserID() else {return}
        if user?.userID == currentUserId {
            //                let currentUser = try await DatabaseManager.shared.getUserData(userId: currentUserId)
            //                self.userHeader = currentUser
            //                if user?.userID != currentUser.userID{
            Task{
                
            
            let followingList =  try await DatabaseManager.shared.fetchFollowingLists(userId: currentUserId)
        }
            self.followButton.setTitle("Düzenle", for: .normal)
            
            
            //                }
            
        }else {
            Task{
                do {
                    let followingList =  try await DatabaseManager.shared.fetchFollowingLists(userId: currentUserId)
                    let followingCount : String = String(followingList.count)
                    following.setTitle("\(followingCount) following", for: .normal)
                    
                    if followingList.contains(user?.userID ?? ""){
                        self.followButton.setTitle("Takipten Çıkar", for: .normal)
                    }else{
                        self.followButton.setTitle("Takip Et", for: .normal)
                    }
                }catch{
                    
                }
            }
            
        }
    }
    
    private let backgroundImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.isUserInteractionEnabled = false
        return img
    }()
    
    private let userImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "noneUser")
        img.image?.withRenderingMode(.alwaysOriginal)
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 40
        img.clipsToBounds = true
        img.isUserInteractionEnabled = false
        return img
    }()
    
    private let username : UILabel = {
       let username = UILabel()
        username.font = UIFont.boldSystemFont(ofSize: 18)
        return username
    }()
    
    private let addStoryIcon:UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let aboutYou : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    let posts : UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("20 Posts", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
     let followers : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("20 Followers", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
     let following : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("20 Following", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    private lazy var buttonStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posts,followers,following])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(followButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let listed:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet")?.withTintColor(.black), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(changeListView(button:)), for: .touchUpInside)
        return button
    }()
    private let listedView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let listed2:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "squareshape.split.3x3"), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(changeListView(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var listStackView : UIStackView = {
      let view = UIStackView(arrangedSubviews: [listed,listed2])
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private let divider : UIView = {
       let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.layer.cornerRadius = 8
        divider.clipsToBounds = true
        return divider
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture       = UITapGestureRecognizer(target: self, action: #selector(backgroundImageTapped(gesture:)))
        let userImageGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto(gesture:)))
        backgroundImage.addGestureRecognizer(tapGesture)
//        backgroundImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(userImageGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = nil
        userImage.image = nil
        backgroundImage.image = nil
        aboutYou.text = nil
    }
    
    private func setLayout(){
        addSubviews(backgroundImage,userImage,buttonStackView,username,aboutYou,listStackView,divider,addStoryIcon,followButton)
       
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(snp.topMargin).offset(0)
            make.leading.equalTo(snp.leading).offset(0)
            make.trailing.equalTo(snp.trailing).offset(0)
            make.height.equalTo(100)
        }
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(-40)
            make.leading.equalTo(snp.leading).offset(30)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(0)
            make.leading.equalTo(userImage.snp_trailingMargin).offset(20)
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(20)
            make.leading.equalTo(snp.leading).offset(20)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.leading.equalTo(username.snp.trailingMargin).offset(10)
            make.trailing.equalTo(snp.trailing).offset(-20)
        }
        
        aboutYou.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(0)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
        listStackView.snp.makeConstraints { make in
            make.bottom.equalTo(divider.snp.top).offset(0)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.height.equalTo(50)
        }

        divider.snp.makeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(0)
            make.leading.equalTo(snp.leading).offset(0)
            make.trailing.equalTo(snp.trailing).offset(0)
            make.height.equalTo(1)
        }
        
        addStoryIcon.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.right.equalTo(userImage.snp.right).offset(0)
            make.bottom.equalTo(userImage.snp.bottom).offset(0)
        }
    }
}

//MARK: Objc Funcs
extension ProfileHeaderView {
    
    @objc func backgroundImageTapped(gesture:UITapGestureRecognizer){
        delegate?.didTapBackgroundImageTapped()
        self.backgroundImage.isUserInteractionEnabled = false
        self.userImage.alpha = 1
        
    }
    @objc func changeProfilePhoto(gesture:UITapGestureRecognizer){
        delegate?.didTapImageButton()
        self.userImage.isUserInteractionEnabled = false
        self.userImage.alpha = 1
    }
    
    
    @objc func changeListView(button : UIButton){
        switch button{
        case listed :
            delegate?.didTapGridButton()
//            listed.tintColor = .black
//            listed2.setTitleColor(<#T##color: UIColor?##UIColor?#>, for: <#T##UIControl.State#>)
        case listed2:
//            listed2.tintColor = .black
//            listed.tintColor = .blue
            delegate?.didTapListButton()
        default:
            fatalError()
        }
    }

    @objc func followButtonAction(){
        if userHeader?.userID != Auth.auth().currentUser?.uid{
            if tapped {
                Task{
                    do {
                        try await DatabaseManager.shared.unFollow(user: self.userHeader!)
                        self.followButton.setTitle("Takipten Çıkar", for: .normal)
                        self.tapped = false
                    }catch{
                        
                    }
                }
            }else {
                Task {
                    do {
                        try await DatabaseManager.shared.follow(user: self.userHeader!)
                        self.followButton.setTitle("Takip Et", for: .normal)
                        self.tapped = true
                    }catch{
//                        error
                    }
                }
            }
        }else{
            self.followButton.setTitle("Düzenle", for: .normal)
            self.userImage.isUserInteractionEnabled = true
            self.backgroundImage.isUserInteractionEnabled = true
            self.userImage.alpha = 0.8
        }
    }
    
    
    
}

extension UIView {
    func addSubviews(_ views : UIView...){
        for view in views{
            addSubview(view)
        }
    }
}
