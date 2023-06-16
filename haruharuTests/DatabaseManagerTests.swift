//
//  DatabaseManagerTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/14.
//

import XCTest
import RealmSwift

@testable import haruharu

final class DatabaseManagerTests: XCTestCase {

    var dbManager: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        
        let config = Realm.Configuration(inMemoryIdentifier: self.name)
        dbManager = DatabaseManager(config: config)
    }
    
    override func tearDown() {
        dbManager = nil
        super.tearDown()
    }

    func testCreateHabit() {
        // Given
        let habitName = "테스트"
        let goalDay = 30
        let createdDate = Date().toString()!
        
            
        // When
        dbManager.createHabit(habitName, goalDay, createdDate, nil)
        
        // Then
        let fetchedHabits = dbManager.realm.objects(Habit.self)
        XCTAssertEqual(fetchedHabits.count, 1)
        XCTAssertEqual(fetchedHabits[0].habitName, habitName)
        XCTAssertEqual(fetchedHabits[0].goalDay, goalDay)
        XCTAssertEqual(fetchedHabits[0].createdDate, createdDate)
        XCTAssertFalse(fetchedHabits[0].isAlarm)
        XCTAssertEqual(fetchedHabits[0].alarmTime, "0900")
        XCTAssertEqual(fetchedHabits[0].startDays.count, 0)
        
    }
    
    func testCreateUser() {
        // Given
        let name = "성환"
        let createdDate = Date().toString()!
        
        // When
        dbManager.createUser(name, createdDate)
        
        // Then
        let fetchedUser = dbManager.realm.objects(User.self).first
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.name, name)
        XCTAssertEqual(fetchedUser?.createdDate, createdDate)
    }
    
    func testFetchUser() {
        //Given
        let user = User()
        user.name = "성환"
        user.createdDate = Date().toString()!
        try! dbManager.realm.write {
            dbManager.realm.add(user)
        }
        
        //when
        let fetchedUser = dbManager.fetchUser().first
        
        //then
        XCTAssertEqual(fetchedUser?.name, user.name, "\(user.name)이 다릅니다.")
        XCTAssertEqual(fetchedUser?.createdDate, user.createdDate, "\(user.createdDate)가 다릅니다.")
    }
    
    func testFetchHabits() {
        //given
        let habit1 = Habit()
        habit1.habitName = "테스트1"
        habit1.goalDay = 30
        habit1.createdDate = Date().toString()!
        habit1.isAlarm = false
        habit1.alarmTime = "0900"
        habit1.startDays = List<HabitDetail>()
        
        
        let habit2 = Habit()
        habit2.habitName = "테스트2"
        habit2.goalDay = 50
        habit2.createdDate = Date().toString()!
        habit2.isAlarm = false
        habit2.alarmTime = "0900"
        habit1.startDays = List<HabitDetail>()
        
        try! dbManager.realm.write {
            dbManager.realm.add(habit1)
            dbManager.realm.add(habit2)
        }
        
        //when
        let fetchedHabits = dbManager.fetchHabits()
        
        //then
        XCTAssertEqual(fetchedHabits.count, 2)
        XCTAssertEqual(fetchedHabits[0].habitName, habit1.habitName)
        XCTAssertEqual(fetchedHabits[0].goalDay, habit1.goalDay)
        XCTAssertEqual(fetchedHabits[0].createdDate, habit1.createdDate)
        XCTAssertEqual(fetchedHabits[0].isAlarm, habit1.isAlarm)
        XCTAssertEqual(fetchedHabits[0].alarmTime, habit1.alarmTime)
        XCTAssertEqual(fetchedHabits[0].startDays.count, 0)
        
        XCTAssertEqual(fetchedHabits[1].habitName, habit2.habitName)
        XCTAssertEqual(fetchedHabits[1].goalDay, habit2.goalDay)
        XCTAssertEqual(fetchedHabits[1].createdDate, habit2.createdDate)
        XCTAssertEqual(fetchedHabits[1].isAlarm, habit2.isAlarm)
        XCTAssertEqual(fetchedHabits[1].alarmTime, habit2.alarmTime)
        XCTAssertEqual(fetchedHabits[1].startDays.count, 0)
    }
    
    func testFetchHabit() {
        //given
        let habit1 = Habit()
        habit1.habitName = "테스트1"
        habit1.goalDay = 30
        habit1.createdDate = Date().toString()!
        habit1.isAlarm = false
        habit1.alarmTime = "0900"
        
        try! dbManager.realm.write {
            dbManager.realm.add(habit1)
        }
        
        let fetchedHabit = dbManager.realm.objects(Habit.self).first
        let habitId = fetchedHabit?._id
        //when
        let habit = dbManager.fetchHabit(id: habitId ?? ObjectId()).first
        //then
        XCTAssertEqual(habit?.habitName, habit1.habitName)
        XCTAssertEqual(habit?.goalDay, habit1.goalDay)
        XCTAssertEqual(habit?.createdDate, habit1.createdDate)
        XCTAssertEqual(habit?.isAlarm, habit1.isAlarm)
        XCTAssertEqual(habit?.alarmTime, habit1.alarmTime)
        
        
    }
    
    func testDeleteHabit() {
        //given
        let habit1 = Habit()
        habit1.habitName = "테스트1"
        habit1.goalDay = 30
        habit1.createdDate = Date().toString()!
        habit1.isAlarm = false
        habit1.alarmTime = "0900"
        habit1.startDays = List<HabitDetail>()
        
        let habit2 = Habit()
        habit2.habitName = "테스트2"
        habit2.goalDay = 50
        habit2.createdDate = Date().toString()!
        habit2.isAlarm = false
        habit2.alarmTime = "0900"
        habit1.startDays = List<HabitDetail>()
        
        try! dbManager.realm.write {
            dbManager.realm.add(habit1)
            dbManager.realm.add(habit2)
        }
        
        let habits = dbManager.realm.objects(Habit.self)
        //when
        dbManager.deleteHabit(id: habits[0]._id)
        
        //then
        XCTAssertEqual(habits.count, 1, "습관이 삭제되지 않았습니다.")
    }
    
    func testUpdateHabitAlarm() {
        //given
        let habit1 = Habit()
        habit1.habitName = "테스트1"
        habit1.goalDay = 30
        habit1.createdDate = Date().toString()!
        habit1.isAlarm = false
        habit1.alarmTime = "0900"
        
        try! dbManager.realm.write {
            dbManager.realm.add(habit1)
        }
        
        var fetchedHabit = dbManager.realm.objects(Habit.self).first
        let alarmDays = List<Int>()
        alarmDays.append(objectsIn: [1, 2])
        
        
        //when
        dbManager.updateHabitAlarm(id: fetchedHabit?._id ?? ObjectId(), isAlarm: true, alarmTime: "1000", alarmDays: alarmDays)
        
        //then
        fetchedHabit = dbManager.realm.objects(Habit.self).first
        XCTAssertEqual(fetchedHabit?.habitName, habit1.habitName, "습관명이 다릅니다.")
        XCTAssertEqual(fetchedHabit?.goalDay, habit1.goalDay, "습관 목표일이 다릅니다.")
        XCTAssertEqual(fetchedHabit?.createdDate, habit1.createdDate, "습관 생성일자가 다릅니다.")
        XCTAssertEqual(fetchedHabit?.isAlarm, true, "알람설정 값이 다릅니다.")
        XCTAssertEqual(fetchedHabit?.alarmTime, "1000", "설정한 알람시간이 아닙니다.")
        XCTAssertEqual(fetchedHabit?.alarmDays.toArray(), [1, 2], "설정한 알람 요일과 다릅니다.")
    }
    
    func testAddHabitDetail() {
        //given
        let habit1 = Habit()
        habit1.habitName = "테스트1"
        habit1.goalDay = 30
        habit1.createdDate = Date().toString()!
        habit1.isAlarm = false
        habit1.alarmTime = "0900"
        habit1.startDays = List<HabitDetail>()
        
        try! dbManager.realm.write {
            dbManager.realm.add(habit1)
        }
        
        var fetchedHabit = dbManager.realm.objects(Habit.self).first
        //when
        dbManager.addHabitDetail(id: fetchedHabit?._id ?? ObjectId())
        //then
        fetchedHabit = dbManager.realm.objects(Habit.self).first
        
        
        XCTAssertEqual(fetchedHabit?.startDays.toArray().count, 1, "habitDetail이 생성되지 않았습니다.")
        XCTAssertEqual(fetchedHabit?.startDays.toArray()[0].check, true, "습관체크가 완료되지 않았습니다.")
        XCTAssertEqual(fetchedHabit?.startDays.toArray()[0].startedDay, Date().toString()!, "습관 완료일자가 다릅니다.")
    }
    
    func testEditUserName() {
        //given
        let newUser = User()
        newUser.name = "성환"
        newUser.createdDate = Date().toString()!
        
        try! dbManager.realm.write {
            dbManager.realm.add(newUser)
        }
        
        var fetchedUser = dbManager.realm.objects(User.self).first
        //when
        dbManager.editUserName(id: fetchedUser?._id ?? ObjectId(), name: "테스트")
        fetchedUser = dbManager.realm.objects(User.self).first
        //then
        
        XCTAssertEqual(fetchedUser?.name, "테스트", "유저 닉네임이 변경되지 않았습니다.")
    }
}
