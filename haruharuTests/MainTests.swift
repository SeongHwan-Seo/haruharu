//
//  MainTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/16.
//
//
import XCTest
import RxSwift
import RxTest
import RealmSwift

@testable import haruharu

final class MainTests: XCTestCase {

    var disposeBag: DisposeBag!
    var viewModel: MainViewModel!
    var databaseManager: DatabaseManager!
    var config: Realm.Configuration!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        config = Realm.Configuration(inMemoryIdentifier: self.name)
        databaseManager = DatabaseManager(config: config)
        viewModel = MainViewModel(db: databaseManager)
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        disposeBag = nil
        config = nil
        databaseManager = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testFetchUser() {
        //given
        let newUser = User(name: "테스트", createdDate: Date().toString()!)
        
        try! databaseManager.realm.write {
            databaseManager.realm.add(newUser)
        }
        
        //when
        let userObserver = scheduler.createObserver(haruharu.User.self)
        scheduler.scheduleAt(0, action: {
            _ = self.viewModel.fetchUser()
                .subscribe(userObserver)
                .disposed(by: self.disposeBag)
        })
        scheduler.start()
        
        //then
        let expectedEvents: [Recorded<Event<haruharu.User>>] = [.next(0, newUser)]
        XCTAssertEqual(userObserver.events, expectedEvents)
    }
    
    func testFetchHabits() {
        //given
        let newHabit1 = Habit()
        newHabit1.habitName = "테스트1"
        newHabit1.goalDay = 30
        newHabit1.createdDate = Date().toString()!
        newHabit1.isAlarm = false
        newHabit1.alarmTime = "0900"
        newHabit1.startDays = List<HabitDetail>()
        
        let newHabit2 = Habit()
        newHabit2.habitName = "테스트2"
        newHabit2.goalDay = 30
        newHabit2.createdDate = Date().toString()!
        newHabit2.isAlarm = false
        newHabit2.alarmTime = "1000"
        newHabit2.startDays = List<HabitDetail>()
        
        try! databaseManager.realm.write {
            databaseManager.realm.add(newHabit1)
            databaseManager.realm.add(newHabit2)
        }
        //when
        let habitsObserver = scheduler.createObserver([Habit].self)
        scheduler.scheduleAt(0, action: {
            _ = self.viewModel.fetchHabits()
                .subscribe(habitsObserver)
                .disposed(by: self.disposeBag)
        })
        scheduler.start()
        //then
        let expectedEvents: [Recorded<Event<[Habit]>>] = [.next(0, [newHabit1, newHabit2])]
        XCTAssertEqual(habitsObserver.events, expectedEvents)
    }
}
