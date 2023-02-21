//
//  AddViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import RxSwift
import RealmSwift

class AddViewModel {
    //Input
    let habitText = BehaviorSubject(value: "")
    let selectedDay = BehaviorSubject(value: 0)
    //output
    let isHabitVaild = BehaviorSubject(value: false)
    let isSelectedDay = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    let db = DatabaseManager.shared
    
    init() {
        
        _ = habitText.distinctUntilChanged()
            .map{ $0.count > 1}
            .bind(to: isHabitVaild)
            .disposed(by: disposeBag)
        
        _ = selectedDay
            .map { $0 > 0}
            .bind(to: isSelectedDay)
            .disposed(by: disposeBag)
    }
    
    func addHabit(habitName: String, goalDay: Int) {
        
        guard let createdDate = Date().toString() else { return }
        let habitDeatil = List<HabitDetail>()
        db.createHabit(habitName, goalDay, createdDate, habitDeatil)
    }
}
