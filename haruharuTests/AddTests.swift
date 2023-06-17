//
//  AddTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/17.
//

import XCTest
import RxSwift
import RxTest
import RealmSwift

@testable import haruharu

final class AddTests: XCTestCase {

    var databaseManager: DatabaseManager!
    var viewModel: AddViewModel!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        
        let config = Realm.Configuration(inMemoryIdentifier: self.name)
        databaseManager = DatabaseManager(config: config)
        viewModel = AddViewModel(db: databaseManager)
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        databaseManager = nil
        viewModel = nil
        disposeBag = nil
        scheduler = nil
        
        super.tearDown()
    }

    func testHabitVaild() {
        let habitTextObserver = scheduler.createObserver(Bool.self)
        
        scheduler.scheduleAt(0) {
            _ = self.viewModel.isHabitVaild
                .bind(to: habitTextObserver)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.scheduleAt(1) {
            self.viewModel.habitText.onNext("Valid Habit")
        }
        
        scheduler.scheduleAt(2) {
            self.viewModel.habitText.onNext("")
        }
        
        scheduler.scheduleAt(3) {
            self.viewModel.habitText.onNext("abcdefghijklmnopqrstuvwxyz")
        }
        
        scheduler.start()
        
        let habitTextEvents = habitTextObserver.events
        XCTAssertEqual(habitTextEvents, [
            .next(0, false), // Initial value
            .next(1, true),  // Valid habit text
            .next(2, false),  // Empty habit text
            .next(3, false)
        ])
    }
    
    func testIsSelectedVaild() {
        let selectedDayObserver = scheduler.createObserver(Bool.self)
        
        scheduler.scheduleAt(0) {
            _ = self.viewModel.isSelectedDay
                .bind(to: selectedDayObserver)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.scheduleAt(1) {
            self.viewModel.selectedDay.onNext(0)
        }
        
        scheduler.scheduleAt(2) {
            self.viewModel.selectedDay.onNext(10)
        }
        
        scheduler.scheduleAt(3) {
            self.viewModel.selectedDay.onNext(30)
        }
        
        scheduler.start()
        
        let habitTextEvents = selectedDayObserver.events
        XCTAssertEqual(habitTextEvents, [
            .next(0, false), // Initial value
            .next(1, false),  // Valid habit text
            .next(2, true),  // Empty habit text
            .next(3, true)
        ])
    }
    
    func testAddHabit() {
        //given
        let habitName = "테스트 입니다."
        let goalDay = 30

        //when
        viewModel.addHabit(habitName: habitName, goalDay: goalDay)
        
        //then
        let fetchedHabit = databaseManager.realm.objects(Habit.self).first
        XCTAssertEqual(fetchedHabit?.habitName, habitName, "추가한 습관명이 다릅니다.")
        XCTAssertEqual(fetchedHabit?.goalDay, goalDay, "추가한 목표일수가 다릅니다.")
    }
}
