//
//  DaysButton.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/08.
//


import UIKit.UIButton
import Foundation


enum DaySelect {
    case thirtyDay
    case fiftyDay
    case hundredDay
}

final class DaysButton: UIButton {
    
    private var daySelect: DaySelect?
    
    override var isSelected: Bool {
        didSet {
            isSelected ? selectConfiguration() : unselectConfiguration()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(daySelect: DaySelect) {
        self.init()
        self.daySelect = daySelect
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }
    
    private func setConfiguration() {
        layer.masksToBounds = true
        switch daySelect {
        case .thirtyDay:
            setButtonText(text: "30일")
        case .fiftyDay:
            setButtonText(text: "50일")
        case .hundredDay:
            setButtonText(text: "100일")
        case .none:
            break
        }
    }
    
    private func setButtonText(text: String) {
        
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont(name: "NanumGothicBold", size: 14)
        
        setBackgroundColor(.textFieldBgColor,cornerRadius: 12, for: .normal)
    }
    
    private func unselectConfiguration() {
        setTitleColor(.white, for: .normal)
        setBackgroundColor(.textFieldBgColor,cornerRadius: 12, for: .normal)
    }
    
    private func selectConfiguration() {
        setBackgroundColor(.btnBgColor,cornerRadius: 12, for: .normal)
        setTitleColor(.white, for: .normal)
    }
}

