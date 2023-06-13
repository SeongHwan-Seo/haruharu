//
//  OnboardingTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/12.
//

import XCTest
import RealmSwift
@testable import haruharu

final class OnboardingTests: XCTestCase {

    var viewModel: OnboardingViewModel!
    var databaseManager: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: self.name)

        databaseManager = DatabaseManager(config: config)
        viewModel = OnboardingViewModel(db: databaseManager)
        
        UserDefaults.standard.removeObject(forKey: "isFirst")
        
    }
    
    override func tearDown() {
        viewModel = nil
        
        UserDefaults.standard.removeObject(forKey: "isFirst")
        
        
        super.tearDown()
    }
    
    func testSetIsFirst() {
        viewModel.setIsFirst()
        
        let isFirst = UserDefaults.standard.bool(forKey: "isFirst")
        
        XCTAssertEqual(isFirst, true, "UserDefaults값이 true가 아닙니다.")
        XCTAssertNotEqual(isFirst, false, "UserDefaults값이 true 입니다.")
    }
    
    func testCreateUser() {
        let nickname = "성환"
        let createdDate = Date().toString()!

        let expectation = self.expectation(description: "User creation expectation")
        
        viewModel.createUser(nickname, createdDate: createdDate)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let users = self.databaseManager.fetchUser()
            XCTAssertEqual(users.count, 1, "User가 생성되지 않았습니다.")
            XCTAssertEqual(users.first?.name, nickname, "생성된 이름이 다릅니다.")
            XCTAssertEqual(users.first?.createdDate, createdDate, "생성된 날짜가 다릅니다.")
            
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateHabit() {
        let habitName = "테스트"
        let goalDay = 30
        
        let expectation = self.expectation(description: "User creation expectation")
        viewModel.createHaibit(habitName: habitName, goalDay: goalDay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let habits = self.databaseManager.fetchHabits()
            XCTAssertEqual(habits.count, 1, "\(habitName)가 생성되지 않았습니다.")
            XCTAssertEqual(habits.first?.habitName, habitName, "생성된 습관과 다릅니다")
            XCTAssertEqual(habits.first?.goalDay, goalDay, "생성된 목표일수와 다릅니다")
            
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 2, handler: nil)
        
    }
   
}
