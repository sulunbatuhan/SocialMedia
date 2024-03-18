//
//  SearchCell.swift
//  DriftKit
//
//  Created by batuhan on 23.12.2023.
//

import UIKit
import SnapKit
import SDWebImage

class SearchCell: UITableViewCell {
    
    var user : User?{
        didSet{
            self.username.text = user?.username
            if let userImageURL = URL(string: user?.userImage ?? ""){
                self.userImage.sd_setImage(with: userImageURL)
            }
        }
    }
    
   private let userImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private lazy var username:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
//    
//    private lazy var followButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Takip Et", for: .normal)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.systemBlue.cgColor
//        return button
//    }()
    
    private func setLayout(){
        contentView.addSubviews(userImage,username/*,followButton*/)
        
        userImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(contentView).offset(12)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        username.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(userImage.snp_rightMargin).offset(24)
            make.right.equalTo(contentView).offset(-12)
            make.height.equalTo(40)
        }
//        followButton.snp.makeConstraints { make in
//            make.centerY.equalTo(self.contentView)
//            make.height.equalTo(30)
//            make.right.equalTo(contentView.snp.right).offset(-24)
//            make.width.equalTo(80)
//        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setLayout()
        
    }

}
