//
//  EventDateUnitTest.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/9/21.
//

import XCTest
@testable import Logi_LookUp

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
    
    func testErrorNetworkCall() throws {
        
        let expectation = self.expectation(description: "Waiting for the network to return")
        
        let networkController = EventsController()
        // Test corupt JSON
        // Test server returns 500
        // Test we have events
        networkController.searchEvent(searchTerm: "") { result in
            
            switch result {
            case .failure(let error):
                XCTAssert(true)
            case .success(let events):
                break
            }
            // GREEN LIGHT
            expectation.fulfill()
        }
        // Wait for the request to return
        // RED LIGHT
        waitForExpectations(timeout: 5) { possibleError in
            // after network calls finishes
        }
    }

}
