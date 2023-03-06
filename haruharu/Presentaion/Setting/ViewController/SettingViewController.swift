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
    let disposeBag = DisposeBag()
    
    lazy var settingView = SettingView()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = settingView
        
        setAttribute()
        bind()
    }
    
    private func bind() {
        print("SettingViewController - bind()")
        
        
        
        viewModel.settingMenu.bind(to: settingView.settingMenuView.tableView.rx.items(cellIdentifier: SettingMenuViewCell.identifier, cellType: SettingMenuViewCell.self)) { (row, item, cell) in
            cell.mainLabel.text = item.title
            switch item {
            case .rating:
                cell.subLabel.text = ""
            case .version:
                cell.subLabel.text = "1.0.0"
            case .privacy:
                cell.subLabel.text = ""
            }
            
            cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
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

