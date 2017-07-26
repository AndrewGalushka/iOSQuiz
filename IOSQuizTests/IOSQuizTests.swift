//
//  IOSQuizTests.swift
//  IOSQuizTests
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import XCTest
@testable import IOSQuiz

class IOSQuizTests: XCTestCase {
    
    override func setUp() {
        print("-----------------------------")
        super.setUp()
    }
    
    override func tearDown() {
        print("-----------------------------")
        super.tearDown()
    }
    
    func testConnection() {
        let sourceURLString = "http://127.0.0.1:9999"
        guard var fetchedURL = URL(string: sourceURLString) else {fatalError("Cannot convert string \(sourceURLString) into URL LINE \(#line)")}
        fetchedURL = fetchedURL.appendingPathComponent("register")
        
    }
    
}
