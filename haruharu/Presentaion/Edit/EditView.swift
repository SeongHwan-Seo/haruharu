//
//  EditView.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/07.
//

import Foundation
import UIKit
import SnapKit


class EditView: UIView {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "별명"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.textColor = .fgTintColor
        textField.backgroundColor = .textFieldBgColor
        textField.placeholder = "변경할 별명을 입력하세요.(최대 8자)"
        textField.font = UIFont(name: "NanumGothic", size: 14)
        textField.addLeftPadding()
        return textField
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("변경하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        btn.setBackgroundColor(.btnBgColor?.withAlphaComponent(0.7),cornerRadius: 12, for: .disabled)
        return btn
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
        [nameLabel, nameField, editBtn].forEach {
            addSubview($0)
        }
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        nameField.snp.makeConstraints{
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(48)
        }
        
        editBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(55)
        }
        
    }
}
