//
//  Advertiser.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit

final class Advertiser: UICollectionViewCell {
    
    static let reuseIdentifier = "advertiser"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
