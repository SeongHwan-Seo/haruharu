//
//  MainViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/14.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    let db = DatabaseManager.shared
    
    let habits = BehaviorSubject<[Habit]>(value:[])
    let disposeBag = DisposeBag()
    
    init() {
        print("MainViewModel init -")
        fetchHabits()
        
    }
    func fetchHabits() {
        let habit = db.fetchHabits()
        
        Observable.changeset(from: habit)
            .subscribe(onNext: { [weak self] array, changes in
                guard let self = self else { return }
                self.habits.onNext(array.toArray())
            })
            .disposed(by: disposeBag)
    }
    
    
    
}
