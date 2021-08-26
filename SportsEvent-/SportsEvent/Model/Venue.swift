//
//  Venue.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/25/21.
//

import Foundation

struct Welcome: Codable {
    let venues: [VenueEvent]
}

struct VenueEvent: Codable {
    let state: String
    let name: String
    let address: String
    let city: String
    let id: Int
}
