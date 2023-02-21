//
//  AddViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import UIKit
import RxSwift

class AddViewController: UIViewController {
    
    lazy var addView = AddView()
    let viewModel = AddViewModel()
    let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hideKeyboardWhenTappedAround()
        bind()
    }
    
    override func loadView() {
        self.view = addView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        addView.habitField.rx.text.orEmpty
            .bind(to: viewModel.habitText)
            .disposed(by: disposeBag)
        
        addView.hundredBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: false, fiftyDay: false, hundredDay: true)
                self.viewModel.selectedDay.onNext(100)
            })
            .disposed(by: disposeBag)
        addView.thirtyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: true, fiftyDay: false, hundredDay: false)
                self.viewModel.selectedDay.onNext(30)
            })
            .disposed(by: disposeBag)
        addView.fiftyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.divideButtonState(thirtyDay: false, fiftyDay: true, hundredDay: false)
                self.viewModel.selectedDay.onNext(50)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.isSelectedDay,  viewModel.isHabitVaild, resultSelector: { $0 && $1 })
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.addView.addBtn.isEnabled = value
            })
            .disposed(by: disposeBag)
        
        addView.addBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                do {
                    try self.viewModel.addHabit(habitName: self.viewModel.habitText.value(), goalDay: self.viewModel.selectedDay.value())
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func divideButtonState(thirtyDay: Bool, fiftyDay: Bool, hundredDay: Bool) {
        addView.thirtyBtn.isSelected = thirtyDay
        addView.fiftyBtn.isSelected = fiftyDay
        addView.hundredBtn.isSelected = hundredDay
    }
}
