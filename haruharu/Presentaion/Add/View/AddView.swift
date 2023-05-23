//
//  AddView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import UIKit
import SnapKit

class AddView: UIView {
    
    lazy var habitLabel: UILabel = {
        let label = UILabel()
        
        label.text = "습관"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var habitField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.textColor = .fgTintColor
        textField.backgroundColor = .textFieldBgColor
        textField.placeholder = "등록할 습관을 입력하세요.(최대 15자)"
        textField.font = UIFont(name: "NanumGothic", size: 14)
        textField.addLeftPadding()
        return textField
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.text = "진행일"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var thirtyBtn = DaysButton(daySelect: .thirtyDay)
    lazy var fiftyBtn = DaysButton(daySelect: .fiftyDay)
    lazy var hundredBtn = DaysButton(daySelect: .hundredDay)
    lazy var daysBtnStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [thirtyBtn, fiftyBtn, hundredBtn])
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    lazy var weekLabel: UILabel = {
        let label = UILabel()
        
        label.text = "반복"
        label.font = UIFont(name: "NanumGothicBold", size: 14)
        return label
    }()
    
    lazy var sundayBtn = WeekButton(weekSelect: .sunday)
    lazy var mondayBtn = WeekButton(weekSelect: .monday)
    lazy var tuesdayBtn = WeekButton(weekSelect: .tuesday)
    lazy var wednesdayBtn = WeekButton(weekSelect: .wednesday)
    lazy var thursdayBtn = WeekButton(weekSelect: .thursday)
    lazy var fridayBtn = WeekButton(weekSelect: .friday)
    lazy var saturdayBtn = WeekButton(weekSelect: .saturday)
    lazy var weekBtnStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn])
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("추가하기", for: .normal)
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
        [habitLabel, habitField, dayLabel, daysBtnStackView, weekLabel, weekBtnStackView, addBtn].forEach {
            addSubview($0)
        }
        [thirtyBtn, fiftyBtn, hundredBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(55)
            }
        }
        
        [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        habitLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        habitField.snp.makeConstraints{
            $0.leading.equalTo(habitLabel.snp.leading)
            $0.top.equalTo(habitLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(48)
        }
        
        dayLabel.snp.makeConstraints{
            $0.leading.equalTo(habitLabel.snp.leading)
            $0.top.equalTo(habitField.snp.bottom).offset(15)
        }
        
        daysBtnStackView.snp.makeConstraints{
            $0.top.equalTo(dayLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        weekLabel.snp.makeConstraints {
            $0.leading.equalTo(habitLabel.snp.leading)
            $0.top.equalTo(daysBtnStackView.snp.bottom).offset(15)
        }
        
        weekBtnStackView.snp.makeConstraints{
            $0.top.equalTo(weekLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        addBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(55)
        }
        
    }
    
}
