//
//  DetailMainViewCell.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/23.
//

import Foundation
import UIKit
import SnapKit

class DetailMainViewCell: UICollectionViewCell {
    static let identifier = "DetailMainViewCell"
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
       
        label.textAlignment = .center
        label.textColor = .textFieldBgColor
        label.font = UIFont(name: "NanumGothicExtraBold", size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .collectionBgColor
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(countLabel)
        
        countLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }
}
