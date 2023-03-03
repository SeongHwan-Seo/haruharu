//
//  SettingViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/02.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit


class SettingViewController: UIViewController {
    
    let viewModel = SettingViewModel()
    
    lazy var settingView = SettingView()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = settingView
        
        setAttribute()
    }
    
    private func bind() {
        
    }
    
    private func setAttribute() {
        self.title = "설정"
        
        if let user = user {
            settingView.settingHeaderView.nicknameLabel.text = "\(user.name)"
            let count = self.viewModel.getCountDate(createdDate: user.createdDate)
            settingView.settingHeaderView.countLabel.text = "하루하루 실천한지 \(count)일째 에요."
        }
    }
    
    private func setLayout() {
        
    }
    
    
}

