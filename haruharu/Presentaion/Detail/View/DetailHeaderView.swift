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
        
        label.font = UIFont(name: "NanumGothicBold", size: 16)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
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
        btn.setTitle("하루완료", for: .disabled)
        btn.setTitleColor(.white, for: .normal)
        
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        btn.setBackgroundColor(.btnBgColor?.withAlphaComponent(0.7),cornerRadius: 12, for: .disabled)
        return btn
    }()
    
    lazy var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var hStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    
    lazy var lineView: UIView = {
       let view = UIView()
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    lazy var alarmVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 13
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var alarmHStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var alarmLabel: UILabel = {
       let label = UILabel()
        
        label.text = "하루 알림"
        label.font = UIFont(name: "NanumGothicBold", size: 16)
        return label
    }()
    
    lazy var alarmSubLabel: UILabel = {
       let label = UILabel()
        
        label.text = "매일 09시 00분 하루 알림"
        label.textColor = .gray
        label.font = UIFont(name: "NanumGothicBold", size: 12)
        return label
    }()
    
    lazy var alarmChangeBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("시간변경", for: .normal)
        btn.setTitleColor(.btnBgColor, for: .normal)
        
        btn.setTitleColor(.gray, for: .disabled)
        
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 12)
        return btn
    }()
    
    lazy var alarmSwitchVStackView: UIStackView = {
        let stackView = UIStackView()
        //stackView.spacing = 5
        stackView.alignment = .trailing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch()
        
        
        alarmSwitch.onTintColor = .btnBgColor
        return alarmSwitch
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
        
        [alarmLabel, alarmSubLabel].forEach {
            alarmVStackView.addArrangedSubview($0)
        }
        
        [alarmSwitch, alarmChangeBtn].forEach {
            alarmSwitchVStackView.addArrangedSubview($0)
        }
        
        [alarmVStackView, alarmSwitchVStackView].forEach {
            alarmHStackView.addArrangedSubview($0)
        }
        
        [hStackView, lineView, alarmHStackView].forEach {
            addSubview($0)
        }
        
        alarmHStackView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        hStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(20)
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
