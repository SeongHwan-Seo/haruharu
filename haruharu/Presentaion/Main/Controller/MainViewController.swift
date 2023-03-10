//
//  MainViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/01.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa



class MainViewController: UIViewController, UITableViewDelegate {
    
    let disposeBag = DisposeBag()
    let viewModel = MainViewModel()
    
    lazy var rightButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        btn.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        return btn
    }()
    
    lazy var mainView = MainView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        self.view = mainView
    }
    
    private func bind() {
     
        viewModel.habits.bind(to: mainView.habitListView.tableView.rx.items(cellIdentifier: "HabitListViewCell", cellType: HabitListViewCell.self)) { (row, item, cell) in
            cell.titleLabel.text = item.habitName
            
            let periodIndex1 = item.createdDate.index(item.createdDate.startIndex, offsetBy: 4)
            let periodIndex2 = item.createdDate.index(item.createdDate.startIndex, offsetBy: 6)
            var createdDate = item.createdDate
            createdDate.insert(".", at: periodIndex2)
            createdDate.insert(".", at: periodIndex1)
            cell.startLabel.text = "\(createdDate) ~"
            
            let angleValue: Double = 360 * (Double(item.startDays.count) / Double(item.goalDay))
            
            cell.countLabel.text = "\(item.startDays.count)"
            cell.circleChart.animate(toAngle: angleValue, duration: 0.8, completion: nil)
            
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        Observable.zip(mainView.habitListView.tableView.rx.modelSelected(Habit.self), mainView.habitListView.tableView.rx.itemSelected)
            .bind { (item, indexPath) in
                print(item)
                print(indexPath)
            }
            .disposed(by: disposeBag)
        
        mainView.plusBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let addViewController = AddViewController()
                self?.navigationController?.pushViewController(addViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func setLayout() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        
    }
    
    
}
