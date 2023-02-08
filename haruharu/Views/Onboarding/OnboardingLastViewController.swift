//
//  OnboardingLastViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/07.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa


class OnboardingLastViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "별명"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.textColor = .fgTintColor
        textField.backgroundColor = .textFieldBgColor
        textField.placeholder = "별명을 입력하세요."
        textField.font = UIFont(name: "NanumGothic", size: 14)
        textField.addLeftPadding()
        
        return textField
    }()
    
    lazy var startBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("시작하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        return btn
    }()
    
    lazy var habitLabel: UILabel = {
        let label = UILabel()
        
        label.text = "습관"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var habitField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.textColor = .fgTintColor
        textField.backgroundColor = .textFieldBgColor
        textField.placeholder = "등록할 습관을 입력하세요."
        textField.font = UIFont(name: "NanumGothic", size: 14)
        textField.addLeftPadding()
        return textField
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.text = "진행일"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var thirtyBtn = DaysButton(daySelect: .thirtyDay)
    lazy var fiftyBtn = DaysButton(daySelect: .fiftyDay)
    lazy var hundredBtn = DaysButton(daySelect: .hundredDay)
    
    lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [thirtyBtn, fiftyBtn, hundredBtn])
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.hideKeyboardWhenTappedAround()
        
        bind()
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension OnboardingLastViewController {
    private func bind() {
        textField.rx.text
            .orEmpty
            .map{$0.count > 1}
            .subscribe(onNext: { [weak self] value in
                if value {
                    UIView.transition(with: self!.habitLabel, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self?.habitLabel.isHidden = false
                    })
                    UIView.transition(with: self!.habitField, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self?.habitField.isHidden = false
                    })
                } else {
                    self?.habitField.isHidden = true
                    self?.habitLabel.isHidden = true
                }
                
            })
            .disposed(by: disposeBag)
        habitField.rx.text
            .orEmpty
            .map{ $0.count > 0}
            .subscribe(onNext: { [weak self] value in
                self?.textField.isEnabled = !value
                UIView.transition(with: self!.dayLabel, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self?.dayLabel.isHidden = !value
                })
            })
            .disposed(by: disposeBag)
        habitField.rx.text
            .orEmpty
            .map{ $0.count > 1}
            .subscribe(onNext: { [weak self] value in
                UIView.transition(with: self!.dayLabel, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self?.dayLabel.isHidden = !value
                    self?.horizontalStackView.isHidden = !value
                    
                })
            })
            .disposed(by: disposeBag)
        hundredBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.divideButtonState(thirtyDay: false, fiftyDay: false, hundredDay: true)
            })
            .disposed(by: disposeBag)
        thirtyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.divideButtonState(thirtyDay: true, fiftyDay: false, hundredDay: false)
            })
            .disposed(by: disposeBag)
        fiftyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.divideButtonState(thirtyDay: false, fiftyDay: true, hundredDay: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .bgColor
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        self.habitLabel.isHidden = true
        self.habitField.isHidden = true
        self.dayLabel.isHidden = true
        self.horizontalStackView.isHidden = true
    }
    
    private func setLayout() {
        [dayLabel, textField, nickNameLabel, startBtn, habitField, habitLabel, horizontalStackView].forEach {
            self.view.addSubview($0)
        }
        
        thirtyBtn.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        fiftyBtn.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        hundredBtn.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        horizontalStackView.snp.makeConstraints{
            $0.top.equalTo(dayLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        dayLabel.snp.makeConstraints{
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.top.equalTo(habitField.snp.bottom).offset(15)
        }
        
        textField.snp.makeConstraints{
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(48)
        }
        
        nickNameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        habitLabel.snp.makeConstraints{
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.top.equalTo(textField.snp.bottom).offset(15)
        }
        
        habitField.snp.makeConstraints{
            $0.leading.equalTo(habitLabel.snp.leading)
            $0.height.equalTo(textField.snp.height)
            $0.trailing.equalTo(textField.snp.trailing)
            $0.top.equalTo(habitLabel.snp.bottom).offset(15)
        }
        
        startBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(55)
        }
    }
    
    private func divideButtonState(thirtyDay: Bool, fiftyDay: Bool, hundredDay: Bool) {
        self.thirtyBtn.isSelected = thirtyDay
        self.fiftyBtn.isSelected = fiftyDay
        self.hundredBtn.isSelected = hundredDay
    }
}
