//
//  EventsControllerTest.swift
//  SportsEventTests
//
//  Created by Juan M Mariscal on 8/23/21.
//

import XCTest
@testable import SportsEvent

class EventsControllerTest: XCTestCase {

    func testSearchURLRequestGeneration() {
        let searchTerm = "Soccer"
        let eventController = EventsController()
        
        let request = eventController.generateSearchTermRequest(searchTerm: searchTerm)
        XCTAssertTrue(((request.url?.query?.contains(searchTerm)) == true))
    }

}
