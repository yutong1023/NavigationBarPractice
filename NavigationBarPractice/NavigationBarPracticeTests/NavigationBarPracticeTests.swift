//
//  NavigationBarPracticeTests.swift
//  NavigationBarPracticeTests
//
//  Created by yutong on 2021/10/26.
//

import XCTest
@testable import NavigationBarPractice

class NavigationBarPracticeTests: XCTestCase {
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAsynchronousAPI() {
        var responseError: String?
        var getPlantSucc = false
        let promise = expectation(description: "Invalid status code.") // 若是執行錯誤則會 log 出來的訊息
        
        let plantsService = PlantsService()
        plantsService.getPlants { success, model, error in
            responseError = error
            getPlantSucc = success
            promise.fulfill()
        }
        wait(for: [promise], timeout: 8) // 設定被測試的 API 的 Timeout 時間
                
        XCTAssertNil(responseError, "Response is error.")
        XCTAssert(getPlantSucc)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
