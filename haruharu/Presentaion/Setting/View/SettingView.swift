//
//  SettingView.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/02.
//

import Foundation
import UIKit
import SnapKit

class SettingView: UIView {
    
    lazy var settingHeaderView = SettingHeaderView()
    
    lazy var logoView: UIImageView = {
       let imageView = UIImageView()
        
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
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
        [settingHeaderView, logoView].forEach{
            addSubview($0)
        }
        
        
        settingHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
    }
}
