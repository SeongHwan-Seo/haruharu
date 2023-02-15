//
//  HabitListView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/14.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class HabitListView: UIView, UITableViewDelegate {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("HabitListView init")
        
        setAttribute()
        setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {

    }
    
    private func setAttribute() {
        tableView.register(HabitListViewCell.self, forCellReuseIdentifier: HabitListViewCell.identifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgColor
        tableView.rowHeight = 140
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
