//
//  ConfirmPopupViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/24.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class ConfirmPopupViewController: UIViewController {
    let animationView: LottieAnimationView = .init(name: "complete2")
    
    var completionClosure: (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setAttribute()
        setLayout()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            //2초후 실행될부분
            self.dismiss(animated: false)
            if let completionClosure = self.completionClosure {
                completionClosure()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        
        animationView.backgroundColor = .black.withAlphaComponent(0.6)
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.6
        animationView.play()
    }
    
    private func setLayout() {
        self.view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}
