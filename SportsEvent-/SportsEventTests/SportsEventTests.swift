//
//  SportsEventTests.swift
//  SportsEventTests
//
//  Created by Juan M Mariscal on 8/13/21.
//

import XCTest
@testable import SportsEvent

class SportsEventTests: XCTestCase {
    
    func testDecodingWorks() throws {
        let bundle = Bundle(path: Bundle.main.bundlePath.appending("/PlugIns/SportsEventTests.xctest"))!
        let url = bundle.url(forResource: "Events", withExtension: "json")!
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let events = try decoder.decode(Events.self, from: data)
        
        XCTAssertEqual(10, events.events.count)
        XCTAssertNotEqual(9, events.events.count)
        XCTAssertNotEqual(11, events.events.count)
    }
    
    func testGrabbingImage() throws {
        let expectation = self.expectation(description: "Waiting for network to return")
        
        let imageStringPath = "https://seatgeek.com/images/performers-landscape/generic-football-07ce3f/677211/32399/huge.jpg"
        let eventController = EventsController()
        
        eventController.grabImageFromEvent(path: imageStringPath) { result in
            
            switch result{
            
            case .success(let success):
                XCTAssert(true)
            case .failure(let error):
                break
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { possibleError in
            
        }
    }


}
