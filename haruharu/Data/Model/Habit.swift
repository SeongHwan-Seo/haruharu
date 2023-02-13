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
    
    convenience init(id: Int, habitName: String, goalDay: Int) {
        self.init()
        
        self.habitName = habitName
        self.goalDay = goalDay
    }
    
    
}
