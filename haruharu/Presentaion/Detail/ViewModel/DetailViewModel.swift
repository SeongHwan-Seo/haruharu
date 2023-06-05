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
    let habit = BehaviorRelay<Habit>(value: Habit())
    
    //input
    let selectedWeek = BehaviorRelay<[WeekSelect.RawValue]>(value: [])
    //let newSelectedWeek = BehaviorRelay<[WeekSelect.RawValue]>(value: [])
    
    //output
    let isCompletedGoal = BehaviorRelay(value: false) // 목표일수 달성
    let isCompletedDay = BehaviorRelay(value: false) // 오늘목표 달성
    let isSelectedWeek = BehaviorRelay(value: false) // 반복 요일을 선택했는지
    let selectedDaysName = BehaviorRelay(value: "") // 반복 요일 선택이름 (ex - 주말, 평일, 월 화 목)
    
    init(habitId: ObjectId) {
        let habit = db.fetchHabit(id: habitId)
        Observable.changeset(from: habit)
            .subscribe(onNext: { [weak self] array, changes in
                guard let self = self else { return }
                if !array.toArray().isEmpty {
                    self.habit.accept(array.toArray()[0])
                }
            })
            .disposed(by: disposeBag)
        
        
        _ = selectedWeek
            .map { $0.count > 0 }
            .bind(to: isSelectedWeek)
            .disposed(by: disposeBag)
        
        self.habit
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.selectedWeek.accept(value.alarmDays.toArray())
            })
            .disposed(by: disposeBag)
        
        _ = selectedWeek.map { selectedWeekArray -> String in
            let sortedArray = selectedWeekArray.sorted()
            
            if sortedArray == [1, 7] {
                return "주말"
            } else if sortedArray == [2, 3, 4, 5, 6] {
                return "평일"
            } else if sortedArray == [1, 2, 3, 4, 5, 6, 7]{
                return "매일"
            } else {
                let weekdays = sortedArray.map { weekday in
                    switch weekday {
                    case 1: return "일"
                    case 2: return "월"
                    case 3: return "화"
                    case 4: return "수"
                    case 5: return "목"
                    case 6: return "금"
                    case 7: return "토"
                    default: return ""
                    }
                }
                return weekdays.joined(separator: " ")
            }
        }
        .subscribe(onNext: { [weak self] dayOfWeek in
            guard let self = self else { return }
            self.selectedDaysName.accept(dayOfWeek)
        })
        .disposed(by: disposeBag)
    }
    
    func setSelectedWeek() {
        selectedWeek.accept(habit.value.alarmDays.toArray())
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
        let newSelectedDaysList = List<Int>()
        for value in selectedWeek.value {
            newSelectedDaysList.append(value)
        }
        
        
        db.updateHabitAlarm(id: id, isAlarm: isAlarm, alarmTime: alarmTime, alarmDays: newSelectedDaysList)
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
    
    func addNotificationRequest(days: [Int],  hour: Int, minute: Int, id: String, habitName: String) {
        //기존 알림 삭제 후 재등록
        deleteNotificationRequest(id: id)
        
        
        let center = UNUserNotificationCenter.current()
        // content 만들기
        let content = UNMutableNotificationContent()
        content.title = "하루 습관을 실천할 시간이에요!"
        content.body = "[\(habitName)] 실천하러 가기"
        content.sound = .default
        
        var dateComponents = DateComponents()
        
        let calendar = Calendar.current
        
        dateComponents.hour = hour
        dateComponents.minute = minute
         
        
        for day in days {
            dateComponents.weekday = day
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(id)\(day)", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if let error = error {
                    print("알림 예약에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteNotificationRequest(id: String) {
        let days = [1, 2, 3, 4, 5, 6, 7]
        
        
        let center = UNUserNotificationCenter.current()
        //기존 등록되어 있던 identifier 삭제
        center.removePendingNotificationRequests(withIdentifiers: [id])
        
        //새로 요일별로 등록한 identifer 삭제
        for day in days {
            let identifier = "\(id)\(day)"
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}
