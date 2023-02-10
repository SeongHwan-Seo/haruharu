//
//  DatabaseManager.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/10.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func addUser(_ user: Object) {
        do {
            realm.add(user)
        }
    }
    
}
