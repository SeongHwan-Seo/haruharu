//
//  SettingMenuView.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/06.
//

import Foundation
import UIKit
import SnapKit

class SettingMenuView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("SettingMenuView init")
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        tableView.register(SettingMenuViewCell.self, forCellReuseIdentifier: SettingMenuViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgColor
        tableView.rowHeight = 50
    }
    
    private func setLayout() {
        [tableView].forEach {
            addSubview($0)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
}
