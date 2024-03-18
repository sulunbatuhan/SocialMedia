//
//  PostHeaderView.swift
//  Social
//
//  Created by batuhan on 28.02.2024.
//

import Foundation
import UIKit


protocol HeaderViewDelegate :AnyObject{
    func didTapImage(_ index:UIImage)
}

final class PostHeaderView :UICollectionReusableView,HeaderViewDelegate {
    
    static let reuseIdentifier = "postShareHeader"
    
    lazy var  backgroundImage : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: initalize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Methods
    private func setLayout(){
        addSubview(backgroundImage)
        backgroundImage.frame = bounds
    }
    
    func didTapImage(_ index: UIImage) {
        backgroundImage.image = index
    }

    
}
