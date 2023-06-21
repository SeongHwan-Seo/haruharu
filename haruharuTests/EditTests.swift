//
//  EditTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/21.
//

import XCTest
import RxTest
import RxSwift
import RealmSwift

@testable import haruharu

final class EditTests: XCTestCase {

    var viewModel: EditViewModel!
    var databaseManager: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        
        let config = Realm.Configuration(inMemoryIdentifier: self.name)
        databaseManager = DatabaseManager(config: config)
        viewModel = EditViewModel(db: databaseManager)
        
    }
    
    override func tearDown() {
        viewModel = nil
        databaseManager = nil
        
        super.tearDown()
    }
    
    func testEditUserName() {
        //given
        let newUser = User(name: "테스트", createdDate: Date().toString()!)
        try! databaseManager.realm.write {
            databaseManager.realm.add(newUser)
        }
        
        var fetchedUser = databaseManager.realm.objects(User.self).first
        
        //when
        viewModel.editName(id: fetchedUser?._id ?? ObjectId(), name: "테스트2")
        
        //then
        fetchedUser = databaseManager.realm.objects(User.self).first
        XCTAssertEqual(fetchedUser?.name, "테스트2", "유저 name이 변경되지 않았습니다.")
    }
    

}
