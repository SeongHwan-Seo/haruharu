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
    
    init() {
        print("MainViewModel init -")
        fetchHabits()
    }
    func fetchHabits() {
        habits.onNext(db.fetchHabits())
    }
    
}
