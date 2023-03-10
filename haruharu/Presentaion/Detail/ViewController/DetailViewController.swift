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
import RealmSwift


class DetailViewController: UIViewController, UIScrollViewDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let disposeBag = DisposeBag()
    
    let viewModel = DetailViewModel()
    
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
        print("DetailViewController init")
        
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
        guard let habit = habit else { return }
        
        viewModel.isComplete(habit: habit)
        
        deleteBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let popupViewController = DeletePopupViewController()
                popupViewController.modalPresentationStyle = .overFullScreen
                
                popupViewController.confirmBtnCompletionClosure = {
                    self.viewModel.deleteNotificationRequest(id: habit._id.stringValue)
                    self.viewModel.deleteHabit(id: habit._id)
                    self.navigationController?.popViewController(animated: true)
                }
                
                self.present(popupViewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        detailView.detailMainView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        detailView.detailHeaderView.chkBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.addHabitDetail(id: habit._id)
                
                let popupViewController = ConfirmPopupViewController()
                popupViewController.modalPresentationStyle = .overFullScreen
                
                popupViewController.completionClosure = {
                    self?.navigationController?.popViewController(animated: true)
                }
                
                self?.present(popupViewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        Observable.from([1...habit.goalDay])
            .bind(to: detailView.detailMainView.collectionView.rx.items(cellIdentifier: DetailMainViewCell.identifier, cellType: DetailMainViewCell.self)) { (row, item, cell) in
                
                if habit.startDays.count >= item {
                    cell.countLabel.textColor = .white
                    //cell.countLabel.tintColor = .white
                    if habit.startDays.toArray()[row].startedDay == Date().toString() {
                        cell.backgroundColor = .collectionChkBgColor
                    } else {
                        cell.backgroundColor = .collectionChkBgColor?.withAlphaComponent(0.7)
                    }
                    
                } else {
                    cell.countLabel.text = "\(item)"
                    cell.backgroundColor = .collectionBgColor
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isCompletedGoal
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.detailView.detailHeaderView.chkBtn.isEnabled = !value
            })
            .disposed(by: disposeBag)
        
        detailView.detailHeaderView.alarmSwitch.rx.isOn
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let time = habit.alarmTime
                if value {
                    let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
                    
                    self.userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
                        
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        DispatchQueue.main.sync {
                            if !success {
                                // ?????? ??????????????? ?????? ?????? ?????? ?????? ??? ??????????????? ??????
                                self.detailView.detailHeaderView.alarmSwitch.setOn(false, animated: true)
                                self.detailView.detailHeaderView.alarmChangeBtn.isEnabled = false
                                self.viewModel.deleteNotificationRequest(id: habit._id.stringValue)
                                self.viewModel.updateHabitAlarm(id: self.habit!._id, isAlarm: false, alarmTime: time)
                                
                                let permissionPopupVC = PermissionPopupViewController()
                                permissionPopupVC.modalPresentationStyle = .overFullScreen
                                permissionPopupVC.confirmBtnCompletionClosure = {
                                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                                    
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                self.present(permissionPopupVC, animated: false)
                                
                                
                            } else {
                                self.detailView.detailHeaderView.alarmChangeBtn.isEnabled = value
                                
                                
                                var dateComponents = DateComponents()
                                dateComponents.calendar = Calendar.current
                                
                                dateComponents.hour = Int(time.prefix(2))
                                dateComponents.minute = Int(time.suffix(2))
                                
                                self.viewModel.addNotificationRequest(by: dateComponents, id: self.habit!._id.stringValue, habitName: self.habit!.habitName)
                                self.viewModel.updateHabitAlarm(id: self.habit!._id, isAlarm: true, alarmTime: time)
                            }
                        }
                    }
                } else {
                    self.detailView.detailHeaderView.alarmChangeBtn.isEnabled = value
                    self.viewModel.deleteNotificationRequest(id: habit._id.stringValue)
                    self.viewModel.updateHabitAlarm(id: self.habit!._id, isAlarm: false, alarmTime: time)
                }
            })
            .disposed(by: disposeBag)
        
        
        detailView.detailHeaderView.alarmChangeBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let timePickerPopupVC = TimePickerPopupViewController()
                timePickerPopupVC.modalPresentationStyle = .overFullScreen
                
                timePickerPopupVC.confirmBtnCompletionClosure = {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
                    
                    let time = dateFormatter.string(from: timePickerPopupVC.timePicker.date)
                    
                    self.detailView.detailHeaderView.alarmSubLabel.text = "?????? \(time.prefix(2))??? \(time.suffix(2))??? ?????? ??????"
                    
                    var dateComponents = DateComponents()
                    dateComponents.calendar = Calendar.current
                    
                    dateComponents.hour = Int(time.prefix(2))
                    dateComponents.minute = Int(time.suffix(2))
                    
                    self.viewModel.addNotificationRequest(by: dateComponents, id: self.habit!._id.stringValue, habitName: self.habit!.habitName)
                    self.viewModel.updateHabitAlarm(id: self.habit!._id, isAlarm: true, alarmTime: time)
                }
                self.present(timePickerPopupVC, animated: false)
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
 
        detailView.detailHeaderView.alarmSwitch.setOn(habit.isAlarm, animated: false)
        detailView.detailHeaderView.alarmSubLabel.text = "?????? \(habit.alarmTime.prefix(2))??? \(habit.alarmTime.suffix(2))??? ?????? ??????"
        
    }
    
    private func setLayout() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteBtn)
        
    }
    
}


extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 6
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 5
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}

