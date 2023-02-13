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
    let viewModel = OnboardingViewModel()
    
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
        //btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .disabled)
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
        
        textField.rx.text.orEmpty
            .bind(to: viewModel.nicknameText)
            .disposed(by: disposeBag)
        
        habitField.rx.text.orEmpty
            .bind(to: viewModel.habitText)
            .disposed(by: disposeBag)
        
        viewModel.isNicknameVaild
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value {
                    UIView.transition(with: self.habitLabel, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self.habitLabel.isHidden = !value
                    })
                    UIView.transition(with: self.habitField, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self.habitField.isHidden = !value
                    })
                } else {
                    self.habitLabel.isHidden = !value
                    self.habitField.isHidden = !value
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isHabitVaild
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value {
                    UIView.transition(with: self.dayLabel, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self.dayLabel.isHidden = !value
                    })
                    UIView.transition(with: self.horizontalStackView, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self.horizontalStackView.isHidden = !value
                    })
                    self.textField.isEnabled = !value
                } else {
                    self.dayLabel.isHidden = !value
                    self.horizontalStackView.isHidden = !value
                    self.textField.isEnabled = !value
                }
            })
            .disposed(by: disposeBag)

        hundredBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: false, fiftyDay: false, hundredDay: true)
                self.viewModel.selectedDay.onNext(100)
            })
            .disposed(by: disposeBag)
        thirtyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: true, fiftyDay: false, hundredDay: false)
                self.viewModel.selectedDay.onNext(30)
            })
            .disposed(by: disposeBag)
        fiftyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: false, fiftyDay: true, hundredDay: false)
                self.viewModel.selectedDay.onNext(50)
            })
            .disposed(by: disposeBag)
        
        startBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // Realm 파일 위치
               
                do {
                    try self.viewModel.createHaibit(habitName: self.viewModel.habitText.value(), goalDay: self.viewModel.selectedDay.value())
                    try self.viewModel.setNickname(self.viewModel.nicknameText.value())
                    self.viewModel.setIsFirst()
                    
                    
                    let vc = MainViewController()
                    vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    vc.modalTransitionStyle = .flipHorizontal
                    self.present(vc, animated: true, completion: nil)
                } catch {
                    
                }
                
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.isSelectedDay, viewModel.isNicknameVaild, viewModel.isHabitVaild, resultSelector: { $0 && $1 && $2})
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.startBtn.isEnabled = value
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .bgColor
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        
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
