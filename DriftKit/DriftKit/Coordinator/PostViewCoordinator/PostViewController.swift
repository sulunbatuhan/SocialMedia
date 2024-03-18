//
//  PostViewController.swift
//  DriftKit
//
//  Created by batuhan on 4.01.2024.
//

import Foundation
import UIKit
import SDWebImage

final class PostViewController : UIViewController{
    
    var viewModel : PostViewModel?
    
    func configure(){
        if let userImageURL = URL(string: viewModel?.post.user.userImage ?? ""){
            self.userImage.sd_setImage(with: userImageURL)
        }
        
        if let postImageURL = URL(string: viewModel?.post.postImage ?? ""){
            self.postImage.sd_setImage(with: postImageURL)
        }
        self.userName.text = viewModel?.post.user.username
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(popToController))
        navigationItem.leftBarButtonItem?.tintColor = .black
        configure()
    }
    
    @objc private func popToController(){
        viewModel?.backToController()
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
        return button
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    private func setLayout(){
        view.addSubviews(userImage,userName,dotButton)
        view.addSubview(postImage)
        view.addSubview(buttonStackView)
        
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
            make.top.equalTo(view).offset(4)
            make.left.equalTo(userName.snp_rightMargin).offset(12)
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(40)
            
        }
        
        postImage.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(4)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(view).multipliedBy(0.5)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.topMargin.equalTo(postImage.snp.bottom).offset(4)
            make.left.equalTo(postImage.snp.left).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
    }
    
}
