//
//  DetailFooterView.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/13.
//

import Foundation
import UIKit
import SnapKit

class DetailFooterView: UIView {
    
    lazy var footerLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "NanumGothic", size: 12)
        label.text = "*하루 한 번씩 습관을 완료할 수 있어요."
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(footerLabel)
        
        footerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
