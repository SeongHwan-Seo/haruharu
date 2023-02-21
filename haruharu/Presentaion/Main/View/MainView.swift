//
//  MainView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/13.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

class MainView: UIView {
    
    lazy var habitListView = HabitListView()
    
    lazy var nicknameView = NicknameView()
    
    lazy var plusBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("+", for: .normal)
        btn.clipsToBounds = true
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 43)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 0.5 * 60, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("mainview init")
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setAttribute() {
        self.backgroundColor = .bgColor
        
    }
    
    private func setLayout() {
        [nicknameView, habitListView, plusBtn].forEach {
            addSubview($0)
        }
        
        nicknameView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
        
        habitListView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(nicknameView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview()
        }
        
        plusBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(60)
            
        }
    }
}
