//
//  EventDateUnitTest.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/9/21.
//

import XCTest
@testable import SportsEvent

class EventDateUnitTest: XCTestCase {

    func testISO8601StringSuccessfullyParsesIntoString() throws {
        let testDateString = "2021-08-13T19:00:00"
        let expectedSuccessString = "2021 Aug 13 07:00 PM"

        XCTAssertEqual(testDateString.datePresentationFormat, expectedSuccessString)
        XCTAssertNotNil(testDateString.datePresentationFormat)
    }

    func testInvalidStringFails() throws {
        XCTAssertNil("".datePresentationFormat)
    }

}
