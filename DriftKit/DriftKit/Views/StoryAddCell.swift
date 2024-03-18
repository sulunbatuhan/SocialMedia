//
//  StoryAddCell.swift
//  DriftKit
//
//  Created by batuhan on 22.12.2023.
//

import UIKit
import SnapKit

protocol StoryDelegate{
    func addStory()
}

class StoryAddCell: UICollectionViewCell {
    var delegate               : StoryDelegate?
    
    static let reuseIdentifier = "stories"
    
    

     let userImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noneUser")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    private let addStoryIcon:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(addStory), for: .touchUpInside)
        return button
    }()
    @objc func addStory(){
        delegate?.addStory()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = .systemBlue
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        contentView.addSubview(userImage)
        contentView.addSubview(addStoryIcon)
        userImage.frame = contentView.bounds
        addStoryIcon.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.right.equalTo(userImage.snp.right).offset(0)
            make.bottom.equalTo(userImage.snp.bottom).offset(0)
        }
    }
    
    
}
