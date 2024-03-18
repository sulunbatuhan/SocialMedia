//
//  PhotoCell.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import Foundation
import UIKit

class PhotoCell : UICollectionViewCell {
    
    var post:PostModel?{
        didSet{
            if let url  = URL(string: post?.postImage ?? ""){
                self.backgroundImage.sd_setImage(with: url)
            }
        }
    }
    
    
    let backgroundImage : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout(){
        contentView.addSubview(backgroundImage)
        backgroundImage.frame = contentView.bounds
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        
    }
    
}
