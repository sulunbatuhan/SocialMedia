//
//  AnimationBarView.swift
//  Social
//
//  Created by batuhan on 8.02.2024.
//

import Foundation
import UIKit
import Combine

final class AnimationBarView : UIView {
    
    enum State {
        case starting
        case animating
        case finishing
    }
    
    private  var animator : UIViewPropertyAnimator!
    @Published var state    : State = .finishing
    private var subscribers = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setLayout()
        self.setAnimator()
        self.dependsOnState()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundBarColor : UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.clipsToBounds   = true
        return view
    }()
    
    private lazy var foregroundColor     : UIView = {
        let view             = UIView()
        view.backgroundColor = .white
        view.alpha           = 0
        return view
    }()
    
    
    private func setAnimator(){
        animator = UIViewPropertyAnimator(duration: 3, curve: .easeInOut, animations: {
            self.foregroundColor.transform = .identity
        })
    }
    
    
    private func setLayout(){
        addSubviews(backgroundBarColor)
        backgroundBarColor.addSubview(foregroundColor)
        
        backgroundBarColor.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        foregroundColor.snp.makeConstraints { make in
            make.edges.equalTo(backgroundBarColor)
        }
        
    }
    
    private func dependsOnState(){
        $state.sink { state in
            
            switch state {
                
            case .starting:
                self.setAnimator()
                self.foregroundColor.alpha = 0
                self.animator.stopAnimation(false)
            case .animating:
                
                self.foregroundColor.transform  = .init(scaleX: 0, y: 1)
                self.foregroundColor.transform  = .init(translationX: -self.frame.size.width, y: 0)
                self.foregroundColor.alpha      = 1
                self.animator.startAnimation()
            case .finishing:
                
                self.animator.stopAnimation(true)
                self.foregroundColor.transform = .identity
            }
        }.store(in: &subscribers)
    }
    
    
    func animation(){
        state = .animating
    }
    
    func finish(){
        state = .finishing
    }
    
    func start(){
        state = .starting
    }
    
}
