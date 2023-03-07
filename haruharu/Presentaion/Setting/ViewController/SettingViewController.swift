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
        //setting menu bind in tableview
        viewModel.settingMenu.bind(to: settingView.settingMenuView.tableView.rx.items(cellIdentifier: SettingMenuViewCell.identifier, cellType: SettingMenuViewCell.self)) { [weak self] (row, item, cell) in
            guard let self = self else { return }
            cell.mainLabel.text = item.title
            switch item {
            case .rating:
                cell.subLabel.text = ""
            case .version:
                cell.subLabel.text = "\(self.viewModel.getCurrentVersion())"
            case .alarm:
                cell.subLabel.text = ""
//            case .privacy:
//                cell.subLabel.text = ""
            }
            
            cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
        
        Observable.zip(settingView.settingMenuView.tableView.rx.modelSelected(SettingMenu.self), settingView.settingMenuView.tableView.rx.itemSelected)
            .bind { [weak self] (item, indexPath) in
                guard let self = self else { return }
                switch item {
                case .rating:
                    self.viewModel.goToStore()
                case .version:
                    return
                case .alarm:
                    self.viewModel.goToAlarm()
//                case .privacy:
//                    return
                }
            }
            .disposed(by: disposeBag)
        
        //수정버튼 클릭 이벤트
        settingView.settingHeaderView.editBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let user = self.user else { return }
                let editViewController = EditViewController()
                editViewController.user = user
                editViewController.completionClosure = {
                    self.settingView.settingHeaderView.nicknameLabel.text = editViewController.editView.nameField.text
                }
                self.navigationController?.pushViewController(editViewController, animated: true)
            })
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

