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
import UserNotifications
import RxRelay

class DetailViewModel {
    let db = DatabaseManager.shared
    let disposeBag = DisposeBag()
    
    //input
    let selectedWeek = BehaviorRelay<[WeekSelect.RawValue]>(value: [])
    
    //output
    let isCompletedGoal = BehaviorRelay(value: false) // 목표일수 달성
    let isCompletedDay = BehaviorRelay(value: false) // 오늘목표 달성
    let isSelectedWeek = BehaviorRelay(value: false) // 반복 요일을 선택했는지
    
    init() {
        _ = selectedWeek
            .map { $0.count > 0 }
            .bind(to: isSelectedWeek)
            .disposed(by: disposeBag)
    }
    
    func deleteHabit(id: ObjectId) {
        db.deleteHabit(id: id)
    }
    
    func addHabitDetail(id: ObjectId) {
        // 하루체크가 목표일수 달성 시 알림 삭제
        if db.addHabitDetail(id: id) {
            deleteNotificationRequest(id: id.stringValue)
        }
    }
    
    func updateHabitAlarm(id: ObjectId, isAlarm: Bool, alarmTime: String) {
        db.updateHabitAlarm(id: id, isAlarm: isAlarm, alarmTime: alarmTime)
    }
    
    func setIsCompleteGoal(habit: Habit) {
        let isCompleted = {
            return habit.startDays.toArray().count == habit.goalDay ? true : false
        }
        isCompletedGoal.accept(isCompleted())
        
        setIsCompleteDay(habit: habit)
    }
    
    func setIsCompleteDay(habit: Habit) {
        if isCompletedGoal.value || habit.startDays.toArray().map({ $0.startedDay}).contains(Date().toString()) {
            isCompletedDay.accept(true)
        }
    }
    
    func addNotificationRequest(by date: DateComponents, id: String, habitName: String) {
        
        let center = UNUserNotificationCenter.current()
        // content 만들기
        let content = UNMutableNotificationContent()
        content.title = "하루 습관을 실천할 시간이에요!"
        content.body = "[\(habitName)] 실천하러 가기"
        content.sound = .default
        
        // trigger 만들기
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        // request 만들기
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    func deleteNotificationRequest(id: String) {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
