//
//  DetailViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import RealmSwift

class DetailViewModel {
    let db = DatabaseManager.shared
    
    func deleteHabit(id: ObjectId) {
        db.deleteHabit(id: id)
    }
}
