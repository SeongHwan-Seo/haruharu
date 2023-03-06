//
//  SettingMenuViewCell.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/06.
//

import Foundation
import UIKit
import SnapKit

class SettingMenuViewCell: UITableViewCell {
    static let identifier = "SettingMenuViewCell"
    
    lazy var mainLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "NanumGothicBold", size: 17)
        return label
    }()
    
    lazy var subLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "NanumGothicBold", size: 15)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setAttribute() {
        self.backgroundColor = .bgColor
    }
    
    private func setLayout() {
        [mainLabel, subLabel].forEach {
            addSubview($0)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
