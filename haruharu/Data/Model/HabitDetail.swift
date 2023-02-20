//
//  HabitDetail.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/20.
//

import Foundation
import RealmSwift

class HabitDetail: Object {
    @Persisted var startedDay: String
    @Persisted var check: Bool
    @Persisted var parentCategory = LinkingObjects(fromType: Habit.self, property: "startDays")
    
}
