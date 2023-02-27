//
//  DetailViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

class DetailViewModel {
    let db = DatabaseManager.shared
    let disposeBag = DisposeBag()
    
    //output
    let isCompletedGoal = BehaviorSubject(value: false)
    
    func deleteHabit(id: ObjectId) {
        db.deleteHabit(id: id)
    }
    
    func addHabitDetail(id: ObjectId) {
        db.addHabitDetail(id: id)
    }
    
    
    
    func isComplete(habit: Habit) {
        let isCompleted = {
            return habit.startDays.toArray().count == habit.goalDay ? true : false
        }
        
        isCompletedGoal.onNext(isCompleted())
        
        if isCompleted() {
            isCompletedGoal.onNext(isCompleted())
        } else {
            isCompletedGoal.onNext(habit.startDays.toArray().map { $0.startedDay}.contains(Date().toString()))
        }

    }
}
