//
//  Stories.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit
import SDWebImage

protocol StoryProtocol {
    func didTap(images : [String])
}

final class StoryCell: UICollectionViewCell{
    
    static let reuseIdentifier = "stories"
    
    var story : Story? {
        didSet {
            if let imageURL = URL(string: story?.user.userImage ?? ""){
                userImage.sd_setImage(with: imageURL)
            }
        }
    }
    
    private let userImage : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "myself")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        contentView.addSubview(userImage)
        userImage.frame = contentView.bounds
    }
    
    
}
