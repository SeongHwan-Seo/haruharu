//
//  TimePickerPopupViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TimePickerPopupViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var confirmBtnCompletionClosure: (() -> Void)?
    
    lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .cardViewBgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.datePickerMode = .time
        picker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        return picker
    }()
    
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        return btn
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !self.contentView.frame.contains(location) {
            
            self.dismiss(animated: false)
        }
    }
    
    private func bind() {
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: false)
                
                if let confirmBtnCompletionClosure = self.confirmBtnCompletionClosure {
                    confirmBtnCompletionClosure()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.view.addSubview(contentView)
        [timePicker, confirmBtn].forEach {
            contentView.addSubview($0)
        }
        
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(250)
            $0.centerY.equalToSuperview()
        }
        
        timePicker.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        confirmBtn.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
    }
}
