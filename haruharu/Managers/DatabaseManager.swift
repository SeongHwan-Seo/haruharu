//
//  DatabaseManager.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/10.
//

import RealmSwift
import Foundation
import RxSwift
import RxRealm

class DatabaseManager: DatabaseManagerProtocol {
    //static let shared = DatabaseManager()
    
    //let realm = try! Realm()
    private let realm: Realm
    
    init(config: Realm.Configuration? = nil) {
        if let config = config {
            self.realm = try! Realm(configuration: config)
        } else {
            self.realm = try! Realm()
        }
    }
    
    
    func createHabit(_ habitName: String, _ goalDay: Int, _ createdDate: String, _ startDays: List<HabitDetail>) {
        
        let habit = Habit()
        habit.habitName = habitName
        habit.goalDay = goalDay
        habit.createdDate = createdDate
        habit.isAlarm = false
        habit.alarmTime = "0900"
        habit.startDays = startDays
        
        try! realm.write {
            realm.add(habit)
        }
        
    }
    
    func createUser(_ name: String, _ createdDate: String) {
        let user = User()
        user.name = name
        user.createdDate = createdDate
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func editUserName(id: ObjectId, name: String) {
        if let editUser = realm.objects(User.self).filter(NSPredicate(format: "_id = %@", id)).first{
            try! realm.write{
                editUser.name = name
            }
        }
    }
    
    func addHabitDetail(id: ObjectId) -> Bool {
        if let updateObj = realm.objects(Habit.self).filter(NSPredicate(format: "_id = %@", id)).first{
            try! realm.write{
                guard let statedDay = Date().toString() else { return }
                
                let detail = HabitDetail()
                detail.check = true
                detail.startedDay = statedDay
                updateObj.startDays.append(detail)
                
                
            }
            if updateObj.startDays.count == updateObj.goalDay {
                return true
            }
        } else{
            print("Error")
        }
        
        return false
        
    }
    
    func updateHabitAlarm(id: ObjectId, isAlarm: Bool, alarmTime: String, alarmDays: List<Int>) {
        if let updateObj = realm.objects(Habit.self).filter(NSPredicate(format: "_id = %@", id)).first{
            try! realm.write{
                updateObj.isAlarm = isAlarm
                updateObj.alarmTime = alarmTime
                updateObj.alarmDays = alarmDays
            }
        } else{
            print("Error")
        }
    }
    
    func fetchHabit(id: ObjectId) -> Results<Habit> {
        return realm.objects(Habit.self).filter(NSPredicate(format: "_id = %@", id))
    }
    
    func fetchHabits() -> Results<Habit> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(Habit.self)
    }
    
    func fetchUser() -> Results<User> {
        return realm.objects(User.self)
    }
    
    
    func deleteHabit(id: ObjectId) {
        if let delete = realm.objects(Habit.self).filter(NSPredicate(format: "_id = %@", id)).first{
            try! realm.write{
                realm.delete(delete)
            }
        }
    }
    
    
}
