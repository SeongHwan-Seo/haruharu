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

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func createHabit(_ habitName: String, _ goalDay: Int, _ createdDate: String, _ startDays: List<HabitDetail>) {
        
        let habit = Habit()
        habit.habitName = habitName
        habit.goalDay = goalDay
        habit.createdDate = createdDate
        habit.startDays = startDays
        
        try! realm.write {
            realm.add(habit)
            
        }
        
    }
    
    func addHabitDetail(id: ObjectId) {
        
        if let updateObj = realm.objects(Habit.self).filter(NSPredicate(format: "_id = %@", id)).first{
            try! realm.write{
                guard let statedDay = Date().toString() else { return }
                
                let detail = HabitDetail()
                detail.check = true
                detail.startedDay = statedDay
                updateObj.startDays.append(detail)
            }
            
        } else{
            print("Error")
        }
        
    }
    
    func fetchHabits() -> Results<Habit> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(Habit.self)
        
        
    }
    
}
