//
//  Posts.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit
import SnapKit
import SDWebImage

final class PostsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "posts"
   
    var post:PostModel?{
        didSet{
            if let postURL = URL(string: post?.postImage ?? ""){
                postImage.sd_setImage(with: postURL)
            }
            if let userURL = URL(string: post?.user.userImage ?? ""){
                userImage.sd_setImage(with: userURL)
            }
            
            self.userName.text = post?.user.username
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        userName.text = nil
        userImage.image = nil
    }
    
    
    private let userImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noneUser")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    private let userName:UILabel = {
       let label = UILabel()
        label.text = "Batuhan sulun"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let dotButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
       
        return button
    }()
    
    @objc func menuTapped(){
        
        let deleteAction = UIAction(title:"Sil",image: UIImage(systemName: "trash")){_ in 
            
        }
        let menu = UIMenu(children: [deleteAction])
        dotButton.menu = menu
    }
    
    private let postImage : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "gtr")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = .black
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = .black
        return button
    }()
    
    private lazy var saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = .black
        return button
    }()
    
    private lazy var buttonStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    

    private func setLayout(){
        contentView.addSubviews(userImage,userName,dotButton)
        contentView.addSubview(postImage)
        contentView.addSubview(buttonStackView)
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.left.equalTo(contentView).offset(12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.left.equalTo(userImage.snp_rightMargin).offset(12)
            make.right.equalTo(dotButton.snp_leftMargin).offset(-12)
            make.height.equalTo(40)
        }
        
        dotButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.left.equalTo(userName.snp_rightMargin).offset(12)
            make.right.equalTo(contentView).offset(-12)
            make.height.equalTo(40)
            
        }
        
        postImage.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(4)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(0)
            make.height.equalTo(contentView).multipliedBy(0.6)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.topMargin.equalTo(postImage.snp.bottom).offset(4)
            make.left.equalTo(postImage.snp.left).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
    }
    
    
}
