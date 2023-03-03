//
//  User.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/03.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var createdDate: String
    
}
