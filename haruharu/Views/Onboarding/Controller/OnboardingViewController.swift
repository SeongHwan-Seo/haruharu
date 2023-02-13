//
//  OnboardingViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/06.
//

import Foundation
import UIKit
import SnapKit
import Lottie
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    let animationView: LottieAnimationView = .init(name: "challenge")
    let disposeBag = DisposeBag()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "하루하루 나의 습관 만들기"
        label.font = UIFont(name: "NanumGothicBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "하루하루와 같이\n습관을 만들어볼까요?"
        label.font = UIFont(name: "NanumGothicBold", size: 16)
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
    
    @objc func showPush() {
        let secondVC = OnboardingLastViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}



extension OnboardingViewController {
    private func bind() {
        nextBtn.rx.tap
            .subscribe(onNext:  { [weak self] in
                let onboardingLastViewController = OnboardingLastViewController()
                self?.navigationController?.pushViewController(onboardingLastViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .bgColor
        
        animationView.backgroundColor = .bgColor
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.play()
        
    }
    
    private func setLayout() {
        [animationView, mainLabel, titleLabel, nextBtn].forEach {
            self.view.addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(mainLabel.snp.top).offset(15)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(200)
            $0.height.equalTo(300)
        }
        
        
        mainLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(15)
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
