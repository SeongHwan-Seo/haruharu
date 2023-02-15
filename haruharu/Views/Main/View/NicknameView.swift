//
//  NicknameView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/13.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class NicknameView: UIView {
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "\(UserDefaults.standard.string(forKey: "nickname")  ?? "zzzz")의  \n하루하루"
        label.font = UIFont(name: "NanumGothicBold", size: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("nicknameview init")
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setAttribute() {
        
    }
    
    private func setLayout() {
        [nicknameLabel].forEach {
            addSubview($0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
}
