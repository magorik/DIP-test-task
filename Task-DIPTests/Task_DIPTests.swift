//
//  Task_DIPTests.swift
//  Task-DIPTests
//
//  Created by Георгий on 13/07/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import XCTest
@testable import Task_DIP

class Task_DIPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLine() {
        let parser = JSONParser()
        
        let testLine = "Test"
        
        let resultLine    = parser.convert(object: JSON.String(testLine), type: .Line)
        let resultInteger = parser.convert(object: JSON.String(testLine), type: .Integer)
        let resultDouble  = parser.convert(object: JSON.String(testLine), type: .Double)
        let resultPhone   = parser.convert(object: JSON.String(testLine), type: .PhoneNumber)

        XCTAssertNotNil(resultLine)
        XCTAssertNotNil(resultInteger)
        XCTAssertNotNil(resultDouble)
        XCTAssertNotNil(resultPhone)

        XCTAssertEqual(testLine, resultLine as! String)
        XCTAssertEqual(resultInteger as? ParseError, ParseError.invalidInput)
        XCTAssertEqual(resultDouble as? ParseError, ParseError.invalidInput)
        XCTAssertEqual(resultPhone as? ParseError, ParseError.dontMatch)
    }
    
    func testDouble() {
        let parser = JSONParser()
        
        let testDouble: Double = 123.0
        
        let resultLine    = parser.convert(object: JSON.Number(testDouble), type: .Line)
        let resultInteger = parser.convert(object: JSON.Number(testDouble), type: .Integer)
        let resultDouble  = parser.convert(object: JSON.Number(testDouble), type: .Double)
        let resultPhone   = parser.convert(object: JSON.Number(testDouble), type: .PhoneNumber)
        
        XCTAssertNotNil(resultLine)
        XCTAssertNotNil(resultInteger)
        XCTAssertNotNil(resultDouble)
        XCTAssertNotNil(resultPhone)
        
        XCTAssertEqual(String(testDouble), resultLine as? String)
        XCTAssertEqual(resultInteger as? ParseError, ParseError.invalidInput)
        XCTAssertEqual(testDouble, resultDouble as! Double)
        XCTAssertEqual(resultPhone as? ParseError, ParseError.invalidInput)
    }
    
    func testPhoneNumber() {
        
        let phoneNumber1 = "8(999)20188 44"
        let phoneNumber2 = "1 453 434-43-54"
        let phoneNumber3 = "24.4"
        let phoneNumber4 = "+7 999 201-21-22"
        let phoneNumber5 = "7-999 201-21-22"
        let phoneNumber6 = "e43"
        
        testPhone(number: phoneNumber1, expected: "79992018844")
        testPhone(number: phoneNumber2, expected: ParseError.dontMatch)
        testPhone(number: phoneNumber3, expected: ParseError.dontMatch)
        testPhone(number: phoneNumber4, expected: "79992012122")
        testPhone(number: phoneNumber5, expected: "79992012122")
        testPhone(number: phoneNumber6, expected: ParseError.dontMatch)

    }
    
    func testPhone(number: String, expected: Any) {
        let parser = JSONParser()

        let result = parser.convert(object: JSON.String(number), type: .PhoneNumber)
        
        XCTAssertNotNil(result)
        
        if let expected = expected as? String {
            XCTAssertEqual(result as? String, expected)
        } else if let expected = expected as? ParseError {
            XCTAssertEqual(result as? ParseError, expected)
        }
    }
}
