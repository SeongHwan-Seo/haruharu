//
//  DetailHeaderVier.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/22.
//

import Foundation
import UIKit
import SnapKit


class DetailHeaderView: UIView {
    
    lazy var habitLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "NanumGothicBold", size: 18)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "NanumGothicBold", size: 13)
        label.textColor = .gray
        return label
    }()
    
    lazy var chkBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("하루체크", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        
        return btn
    }()
    
    lazy var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setAttribute() {
        
    }
    
    private func setLayout() {
        [habitLabel, dateLabel].forEach {
            vStackView.addArrangedSubview($0)
        }
        
        [vStackView, chkBtn].forEach {
            hStackView.addArrangedSubview($0)
        }
        
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview().inset(20)
        }
        
        vStackView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        habitLabel.snp.makeConstraints {
            $0.top.leading.equalTo(vStackView)
        }
        
        dateLabel.snp.makeConstraints {
            
            $0.leading.bottom.equalTo(vStackView)
        }
        
        chkBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        
        
        
    }
}
