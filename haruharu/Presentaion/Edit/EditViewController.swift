//
//  EditViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController {
    
    lazy var editView = EditView()
    let viewModel = EditViewModel()
    let disposeBag = DisposeBag()
    var user: User?
    
    var completionClosure: (() -> Void)?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setAttribute()
        bind()
    }
    
    override func loadView() {
        self.view = editView
    }
    
    private func bind() {
        editView.nameField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)
        
        viewModel.isNameVaild
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.editView.editBtn.isEnabled = value
            })
            .disposed(by: disposeBag)
        
        editView.editBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let user = self.user else { return }
                try! self.viewModel.editName(id: user._id, name: self.viewModel.nameText.value())
                if let completionClosure = self.completionClosure {
                    completionClosure()
                }
                self.navigationController?.popViewController(animated: true)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        if let user = user {
            editView.nameField.text = user.name
        }
    }
}
