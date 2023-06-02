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
    
    lazy var settingButton: UIButton = {
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
    override func viewDidAppear(_ animated: Bool) {
        viewModel.isUpdate
            .subscribe(onNext: { [weak self] value in
                if value {
                    guard let self = self else { return }
                    let alertVC = UIAlertController(title: "새로운 버전이 출시되었습니다.", message: "업데이트 하시겠습니까?", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.viewModel.goToStore()
                        self.viewModel.isUpdate.accept(false)
                    }
                    let close = UIAlertAction(title: "닫기", style: .destructive) { _ in
                        self.viewModel.isUpdate.accept(false)
                    }
                    
                    alertVC.addAction(close)
                    alertVC.addAction(confirm)
                    
                    self.present(alertVC, animated: false)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        self.view = mainView
    }
    
    private func bind() {
        
        settingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let settingViewController = SettingViewController()
                try! settingViewController.user = self.viewModel.user.value()
                self.navigationController?.pushViewController(settingViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.habitListView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
     
        viewModel.habits.bind(to: mainView.habitListView.tableView.rx.items(cellIdentifier: "HabitListViewCell",
                                                                            cellType: HabitListViewCell.self)) { (row, item, cell) in
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
                let detailViewController = DetailViewController(habit: item)
                detailViewController.habit = item
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.plusBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let addViewController = AddViewController()
                self?.navigationController?.pushViewController(addViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.user
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.mainView.nicknameView.nicknameLabel.text = "\(user.name)의 \n하루하루"
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func setLayout() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
        
        
    }
    
    
}
