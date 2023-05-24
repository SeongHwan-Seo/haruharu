//
//  TimePickerPopupViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TimePickerPopupViewController: UIViewController {
    weak var viewModel: DetailViewModel?
    weak var delegate: TimePickerPopupDelegate?
    let disposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel, delegate: TimePickerPopupDelegate) {
        print("#TimePickerPopupViewController - init")
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        setLayout()
        bind()
    }
    
    deinit {
        print("#TimePickerPopupViewController - deinit")
    }
    
    var confirmBtnCompletionClosure: (() -> Void)?
    
    lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .cardViewBgColor
        view.layer.cornerRadius = 15
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
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.datePickerMode = .time
        picker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        return picker
    }()
    
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        btn.setBackgroundColor(.btnBgColor?.withAlphaComponent(0.7),cornerRadius: 12, for: .disabled)
        return btn
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !self.contentView.frame.contains(location) { 
            
            self.dismiss(animated: false)
        }
    }
    
    private func bind() {
        let weekBtns: [WeekButton] = [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn]
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didSelectTime(date: self.timePicker.date)
                self.dismiss(animated: false)
                
                if let confirmBtnCompletionClosure = self.confirmBtnCompletionClosure {
                    confirmBtnCompletionClosure()
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.isSelectedWeek
            .subscribe(onNext: { [weak self] val in
                guard let self = self else { return }
                self.confirmBtn.isEnabled = val
            })
            .disposed(by: disposeBag)

//         weekbtn tap event
        for button in weekBtns {
            button.rx.tap
                .scan(false) { acc, _ in !acc }
                .subscribe(onNext: { [weak self, weak button] val in
                    guard let self = self, let button = button else { return }
                    self.divideWeekButtonState(button: button, isSelected: val)

                    var newArray = self.viewModel?.selectedWeek.value
                    guard let selectedRowValue = button.weekSelect?.rawValue else { return }

                    if val { //btn isSelected true
                        newArray?.append(selectedRowValue)
                        self.viewModel?.selectedWeek.accept(newArray ?? [])
                    }
                    else { //btn isSelected false
                        if let index = newArray?.firstIndex(of: selectedRowValue) {
                            newArray?.remove(at: index) // 배열에서 요소 제거
                        }

                        self.viewModel?.selectedWeek.accept(newArray ?? [])
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setLayout() {
        self.view.addSubview(contentView)
        [timePicker, confirmBtn, weekLabel, weekBtnStackView].forEach {
            contentView.addSubview($0)
        }
        
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(400)
            $0.centerY.equalToSuperview()
        }
        
        [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(35)
            }
        }
        
        weekLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
        }
        
        weekBtnStackView.snp.makeConstraints{
            $0.top.equalTo(weekLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        timePicker.snp.makeConstraints {
            $0.top.equalTo(weekBtnStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        confirmBtn.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
    }
    
    private func divideWeekButtonState(button: WeekButton, isSelected: Bool) {
        button.isSelected = isSelected
    }
    
}
