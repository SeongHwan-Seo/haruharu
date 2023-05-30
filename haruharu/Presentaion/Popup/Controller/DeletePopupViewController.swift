//
//  PopupViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DeletePopupViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var confirmBtnCompletionClosure: (() -> Void)?
    
    lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .cardViewBgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "하루습관을 삭제하시겠어요?\n\n삭제된 습관은 복구할 수 없어요!"
        label.font = UIFont(name: "NanumGothicBold", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("취소", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.btnBgColor, for: .normal)
        btn.setBackgroundColor(.btnBgColor?.withAlphaComponent(0.4),cornerRadius: 12, for: .normal)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("삭제", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        return btn
    }()
    
    lazy var vStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancleBtn, confirmBtn])
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        print("#DeletePopupViewController - init")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        setLayout()
        bind()
    }
    
    deinit {
        print("#DeletePopupViewController - deinit")
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
        cancleBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
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
        [contentLabel, vStackView].forEach {
            contentView.addSubview($0)
        }
        
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(250)
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        vStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        cancleBtn.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        confirmBtn.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
    
}
