//
//  DatabaseManagerProtocol.swift
//  haruharu
//
//  Created by SHSEO on 2023/06/13.
//
import Foundation
import RealmSwift

protocol DatabaseManagerProtocol {
    func createHabit(_ habitName: String, _ goalDay: Int, _ createdDate: String, _ startDays: List<HabitDetail>)
    func createUser(_ name: String, _ createdDate: String)
    func editUserName(id: ObjectId, name: String)
    func addHabitDetail(id: ObjectId) -> Bool
    func updateHabitAlarm(id: ObjectId, isAlarm: Bool, alarmTime: String, alarmDays: List<Int>)
    func fetchHabit(id: ObjectId) -> Results<Habit>
    func fetchHabits() -> Results<Habit>
    func fetchUser() -> Results<User>
    func deleteHabit(id: ObjectId)
}
