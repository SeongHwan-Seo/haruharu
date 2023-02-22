//
//  DetailViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        return btn
    }()
    
    lazy var detailView = DetailView()
    
    var habit: Habit?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setAttribute()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    private func bind() {
        detailView.detailHeaderView.chkBtn.rx.tap
            .subscribe(onNext: {
                print("dd")
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setAttribute() {
        guard let habit = habit else { return }
        detailView.detailHeaderView.habitLabel.text = habit.habitName
        
        let periodIndex1 = habit.createdDate.index(habit.createdDate.startIndex, offsetBy: 4)
        let periodIndex2 = habit.createdDate.index(habit.createdDate.startIndex, offsetBy: 6)
        var createdDate = habit.createdDate
        createdDate.insert(".", at: periodIndex2)
        createdDate.insert(".", at: periodIndex1)
        detailView.detailHeaderView.dateLabel.text = "\(createdDate) ~"
        
    }
    
    private func setLayout() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteBtn)
        
    }
    
}
