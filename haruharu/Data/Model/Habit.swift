//
//  UserModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/13.
//

import Foundation
import RealmSwift

class Habit: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var habitName: String
    @Persisted var goalDay: Int
    @Persisted var createdDate: String
    @Persisted var isAlarm: Bool
    @Persisted var alarmTime: String
    @Persisted var startDays: List<HabitDetail>
    
    convenience init(id: Int, habitName: String, goalDay: Int, createdDate: String, isAlarm: Bool,startDays: List<HabitDetail>) {
        self.init()
        
        self.habitName = habitName
        self.goalDay = goalDay
        self.createdDate = createdDate
        self.isAlarm = isAlarm
        self.startDays = startDays
    }
    
    
}
