//
//  EditViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/07.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class EditViewModel {
    //Input
    let nameText = BehaviorSubject(value: "")
    //output
    let isNameVaild = BehaviorSubject(value: false)
    
    
    let disposeBag = DisposeBag()
    
    let db = DatabaseManager.shared
    
    init() {
        _ = nameText.distinctUntilChanged()
            .map{ $0.count > 1 && $0.count < 9}
            .bind(to: isNameVaild)
            .disposed(by: disposeBag)
        
    }
    
    func editName(id: ObjectId, name: String) {
        db.editUserName(id: id, name: name)
    }
}
