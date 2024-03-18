//
//  StoryView.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import UIKit
import SnapKit


    enum Direction {
        case forward
        case backward
    }


class StoryController: UIViewController {
    
    var viewModel : StoryViewModel?
    
    private lazy var storyImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let xButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20), scale: .large)),for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissButton(){
        dismiss(animated: true)
    }
    
    private lazy var barView : [AnimationBarView] = {
        var view = [AnimationBarView]()
        self.viewModel?.stories.forEach({ _ in
            view.append(AnimationBarView())
        })
        return view
    }()
    
    private lazy var barStackView : UIStackView = {
        let stackView = UIStackView()
        barView.forEach { bar in
            let view = UIView()
            view.backgroundColor = .white
            stackView.addArrangedSubview(view)
        }
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    override func viewDidLoad() {
        addGesture()
        viewModel?.returnImage(completion: { url in
            if let url = URL(string: url) {
         
                self.storyImage.sd_setImage(with: url)
            }
        })
        viewModel?.imageObserver = { imageURL in
            self.storyImage.sd_setImage(with: imageURL)
        }
        startAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    private func setLayout(){
        view.addSubviews(storyImage,barStackView,xButton)
        storyImage.frame = view.bounds
        
        barStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(4)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(barStackView.snp.bottom).offset(24)
            make.trailing.equalTo(view.snp_trailing).offset(-24)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }

    
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(storyNavigator(gesture: )))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func storyNavigator(gesture:UITapGestureRecognizer){
        let point = gesture.location(in: self.view)
        let size = view.frame.width / 2
        let position = point.x > size ? true : false
        
        if position {
            handleTap(position: .forward)
        }else {
            handleTap(position: .backward)
        }
    }
    
    
    var timer : DispatchSourceTimer?
    
    
    func buildTimer(){
        guard timer == nil else {return }
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(),repeating: .seconds(3),leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async {
//                self.showNextStory()
            }
        })
    }
    
    
    func showNextStory(){
        var nextBar : AnimationBarView?
        
        self.viewModel?.showNextStory(completion: { [weak self] isContain,storyIndex in
            if isContain{
//                nextBar = self?.barView[storyIndex]
          
            }else {
//                self?.dismiss(animated: true)
                
            }
        })

        UIView.transition(with: storyImage, duration: 0.5, options: .transitionCrossDissolve){
//            self.viewModel?.imageObserver = {  [weak self]imageURL in
//                self?.storyImage.sd_setImage(with: imageURL)
//            }
        }
        nextBar?.animation()
    }
    
    func startAction(){
        buildTimer()
        timer?.resume()
    }
    
    private func handleTap(position:Direction){
        
        switch position {
            
        case .forward:
            viewModel?.forward(completion: { [weak self] index in
//                if let num = index {
//                    if self?.barView.indices.contains(num) {
//                        self.barView[num].finish()
//                    }
//                }
            })
        case .backward:
            viewModel?.backward(completion: { [weak self ] index in
//                if let num = index {
//                    if self?.barView.indices.contains(num) {
//                        self.barView[num].start()
//                    }
//                }
            })
        }
        UIView.transition(with: storyImage, duration: 0.5, options: .transitionCrossDissolve){
            
        }
        timer?.cancel()
        timer = nil
        startAction()
    }
    
    
    
}
