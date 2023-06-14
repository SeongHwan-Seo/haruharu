//
//  OnboardingViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/13.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa

class OnboardingViewModel {
    //Input
    let nicknameText = BehaviorSubject(value: "")
    let habitText = BehaviorSubject(value: "")
    let selectedDay = BehaviorSubject(value: 0)
    //output
    let isNicknameVaild = BehaviorSubject(value: false)
    let isHabitVaild = BehaviorSubject(value: false)
    let isSelectedDay = BehaviorSubject(value: false)
    
    let db: DatabaseManagerProtocol
    
    let disposeBag = DisposeBag()
    
    init(db: DatabaseManagerProtocol = DatabaseManager()) {
        _ = nicknameText.distinctUntilChanged()
            .map{ $0.count > 1 && $0.count < 9}
            .bind(to: isNicknameVaild)
            .disposed(by: disposeBag)
        
        _ = habitText.distinctUntilChanged()
            .map{ $0.components(separatedBy: " ").joined()}
            .map{ $0.count > 1 && $0.count < 16 }
            .bind(to: isHabitVaild)
            .disposed(by: disposeBag)
        
        _ = selectedDay
            .map { $0 > 0}
            .bind(to: isSelectedDay)
            .disposed(by: disposeBag)
        
        self.db = db
    }
    
    func createHaibit(habitName: String, goalDay: Int) {
        guard let createdDate = Date().toString() else { return }
        let habitDeatil = List<HabitDetail>()
        db.createHabit(habitName, goalDay, createdDate, habitDeatil)
    }
    
    
    func createUser(_ nickname: String, createdDate: String) {
        db.createUser(nickname, createdDate)
    }
    
    func setIsFirst() {
        UserDefaults.standard.set(true, forKey: "isFirst")
    }
    
}
