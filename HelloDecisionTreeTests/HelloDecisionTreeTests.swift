//
//  HelloDecisionTreeTests.swift
//  HelloDecisionTreeTests
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import XCTest
@testable import HelloDecisionTree

final class HelloDecisionTreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEntropyOne() {
        let e = entropy(truePositives: 5, trueNegatives: 0, falsePositives: 0, falseNegatives: 0)
        print("e-5-0-0-0: \(e)")
    }
    
    func testEntropyTwo() {
        let e = entropy(truePositives: 5, trueNegatives: 5, falsePositives: 0, falseNegatives: 0)
        print("e-5-5-0-0: \(e)")
    }
    
    func testEntropyThree() {
        let e = entropy(truePositives: 0, trueNegatives: 5, falsePositives: 0, falseNegatives: 0)
        print("e-0-5-0-0: \(e)")
    }

}
