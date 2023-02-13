//
//  DatabaseManager.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/10.
//

import RealmSwift
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func createHabit(_ habitName: String, _ goalDay: Int) {
        
        let habit = Habit()
        habit.habitName = habitName
        habit.goalDay = goalDay
        
        try! realm.write {
            realm.add(habit)
        }
        
        
    }
    
}
