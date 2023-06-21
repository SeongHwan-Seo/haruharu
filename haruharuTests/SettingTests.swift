//
//  SettingTests.swift
//  haruharuTests
//
//  Created by SHSEO on 2023/06/21.
//

import XCTest

@testable import haruharu

final class SettingTests: XCTestCase {
    var viewModel: SettingViewModel!
    override func setUp() {
        super.setUp()
        
        viewModel = SettingViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func testGetCurrentVersion() {
        //given
        let testVersion = "1.1.0"
        
        //when
        let curruntVersion = viewModel.getCurrentVersion()
        
        //then
        XCTAssertEqual(curruntVersion, testVersion, "버전정보가 일치하지 않습니다.")
    }
    
    func testGetCountDate() {
        //given
        let testCreatedDate = "20230621"
        
        //when
        let countDate = viewModel.getCountDate(createdDate: testCreatedDate)
        
        //then
        XCTAssertEqual(countDate, 1, "현재까지 일 수가 잘못되었습니다.")
    }

}
