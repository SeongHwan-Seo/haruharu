//
//  SettingHeaderView.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/02.
//

import Foundation
import UIKit
import SnapKit


class SettingHeaderView: UIView {
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
     
        label.font = UIFont(name: "NanumGothicBold", size: 18)
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
     
        label.textColor = .gray
        label.font = UIFont(name: "NanumGothicBold", size: 13)
        return label
    }()
    
    var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        btn.tintColor = .btnBgColor
        return btn
    }()
    
    var hStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.backgroundColor = .cardViewBgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        
    }
    
    private func setLayout() {
        [nicknameLabel, countLabel].forEach{
            vStackView.addArrangedSubview($0)
        }
        
        [vStackView, editBtn].forEach {
            hStackView.addArrangedSubview($0)
        }
        
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        vStackView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        editBtn.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
//            $0.height.equalTo(50)
//            $0.width.equalTo(100)
        }
    }
}
