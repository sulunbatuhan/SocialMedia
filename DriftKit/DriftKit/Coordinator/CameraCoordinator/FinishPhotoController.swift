//
//  FinishPhotoController.swift
//  DriftKit
//
//  Created by batuhan on 9.01.2024.
//

import Foundation
import UIKit
class FinishPhotoController : UIViewController {
    
    var image : UIImage?{
        didSet{
            imageView.image = image
        }
    }
    
    var imageView : UIImageView = {
       let image = UIImageView()
        return image
    }()
    
    var shareButton : UIButton = {
        let  button = UIButton(type: .system)
        button.setTitle("Paylaş", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(tappedShareButton), for: .touchUpInside)
        return button
    }()
    
    var backButton : UIButton = {
        let  button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        return button
    }()
    
    @objc private func backTo(){
        
    }
    @objc private func tappedShareButton(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    func setLayout(){
        view.addSubview(imageView)
        view.addSubview(shareButton)
        view.addSubview(backButton)
        
        imageView.frame = view.bounds
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        shareButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.snp.leading).offset(50)
//            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
    }
}
