//
//  DetailView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import UIKit

class DetailView: UIView {
    
    lazy var detailHeaderView = DetailHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAttribute() {
        self.backgroundColor = .bgColor
        
    }
    
    private func setLayout() {
        [detailHeaderView].forEach {
            addSubview($0)
        }
        
        detailHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}
