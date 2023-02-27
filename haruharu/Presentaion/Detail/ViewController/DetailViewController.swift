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

class DetailViewController: UIViewController, UIScrollViewDelegate {
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
                    if habit.startDays.toArray()[row].startedDay == Date().toString() {
                        cell.backgroundColor = .collectionChkBgColor
                    } else {
                        cell.backgroundColor = .collectionChkBgColor?.withAlphaComponent(0.7)
                    }
                    
                    
                } else {
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
