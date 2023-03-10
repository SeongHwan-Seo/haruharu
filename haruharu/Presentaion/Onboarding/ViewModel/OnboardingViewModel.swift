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
    
    let disposeBag = DisposeBag()
    
    init() {
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
        
    }
    
    func createHaibit(habitName: String, goalDay: Int) {
        
        let db = DatabaseManager.shared
        
        guard let createdDate = Date().toString() else { return }
        let habitDeatil = List<HabitDetail>()
        db.createHabit(habitName, goalDay, createdDate, habitDeatil)
    }
    
    
    
    /// 유저디폴트 닉네임 저장
    /// - Parameter nickname: 닉네임
    func createUser(_ nickname: String, createdDate: String) {
        let db = DatabaseManager.shared
        
        db.createUser(nickname, createdDate)
    }
    
    func setIsFirst() {
        UserDefaults.standard.set(true, forKey: "isFirst")
    }
    
    
}
