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
    
//    lazy var uiView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 15
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowRadius = 2
//        view.layer.masksToBounds = false
//        view.backgroundColor = .cardViewBgColor
//        //view.backgroundColor = .red
//        return view
//    }()
    
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
        
//        btn.setImage(UIImage(named: "checkIcon"), for: .normal)
//        btn.imageView?.contentMode = .scaleAspectFit
//        btn.semanticContentAttribute = .forceLeftToRight
        //btn.tintColor = .white
        //btn.setPreferredSymbolConfiguration(.init(pointSize: 17, weight: .regular, scale: .default), forImageIn: .normal)
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
        
        self.isUserInteractionEnabled = true
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
//        uiView.addSubview(hStackView)
//        addSubview(uiView)
        addSubview(hStackView)
        
//        uiView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.trailing.leading.equalToSuperview().inset(10)
//
//        }
        
        hStackView.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalTo(uiView).inset(20)
            $0.top.bottom.leading.trailing.equalToSuperview().inset(20)
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
