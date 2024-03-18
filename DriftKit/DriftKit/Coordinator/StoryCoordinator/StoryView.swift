////
////  StoryView.swift
////  Social
////
////  Created by batuhan on 6.02.2024.
////
//
//import Foundation
//import UIKit
//import SDWebImage
//import SnapKit
//
//final class StoryView : UIView {
//    
//    enum Direction {
//        case forward
//        case backward
//    }
//    var viewModel : StoryViewModel?
//    var direction : Direction = .forward
//    var stories   = [Story]()
//    var countBars : Int = 0
//    
//    init(viewModel : StoryViewModel) {
//        self.viewModel = viewModel
//        addGesture()
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setLayout()
//    }
//
//    
//    private let storyImage : UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "gtr")
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//        return image
//    }()
//    
//    
//    private let barView : UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        return view
//    }()
//    
//    
//    private lazy var barStackView : UIStackView = {
//        let stackView = UIStackView()
//       countBars.forEach { bar in
//            let view = UIView()
//            view.backgroundColor = .red
//            stackView.addArrangedSubview(view)
//        }
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//  
//    
//    
//    private lazy var tapGesture : UITapGestureRecognizer = {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(storyNavigator(gesture:)))
//        gesture.numberOfTapsRequired = 1
//        gesture.delegate = self
//        gesture.cancelsTouchesInView = false
//        return gesture
//    }
//    
//    
//    func addGesture(){
//        storyImage.addGestureRecognizer(tapGesture)
//        
//    }
//    
//    private var storyIndex : Int = -1
//    
//    
//    @objc private func storyNavigator(gesture:UITapGestureRecognizer){
//        
//        let point = gesture.location(in: self)
//        let size = storyImage.frame.size / 2
//        let position = point.x > size ? true : false
//        
//        if position {
//            handleTap(position: .forward)
//        }else {
//            handleTap(position: .backward)
//        }
//    }
//    
//    private func handleTap(position:Direction){
//        switch position {
//            
//        case .forward:
//            forward()
//            
//        case .backward:
//            backward()
//        }
//    }
//    
//    
//    
//    func forward(){
//        if storyIndex < 0  || stories.indices.contains(storyIndex) {
//            storyIndex += 1
//            if let imageURL = stories[storyIndex].story {
//                storyImage.sd_setImage(with: imageURL)
//            }
//        }
//   
//        
//    }
//    func backward(){
//        if stories.indices.contains(storyIndex) {
//            storyIndex -= 2
//            if let imageURL = stories[storyIndex].story {
//                storyImage.sd_setImage(with: imageURL)
//            }
//        }
//        
//    }
//    
//    
//    private func setLayout(){
//        addSubviews(storyImage,barStackView)
//        storyImage.frame = self.bounds
//        
//        barStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.snp_topMargin)
//            make.leading.equalTo(self.snp.leading).offset(24)
//            make.trailing.equalTo(self.snp.trailing).offset(-24)
//            make.height.equalTo(4)
//        }
//    }
//    
//
//    
//}
