//
//  OnboardingViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/06.
//

import Foundation
import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "하루하루와 같이\n습관을 만들어볼까요?"
        label.font = UIFont(name: "NanumGothicBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        return btn
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        [titleLabel, nextBtn].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .systemBackground
        
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        nextBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(55)
        }
    }
}
