//
//  Event.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//
import Foundation

// MARK: - Events
struct Events: Codable {
    let events: [Event]
}

struct Event: Codable {
    let shortTitle: String
    let datetimeLocal: String
    let venue: Venue
    let performers: [Performers]
    let id: Int
    let url: String
    let timeTBD: Bool

    enum CodingKeys: String, CodingKey {
        case shortTitle = "short_title"
        case datetimeLocal = "datetime_local"
        case timeTBD = "time_tbd"
        case venue
        case performers
        case id
        case url
    }
}

// MARK: - Images
struct Images: Codable {
    let large, huge, small, medium: String
}

// MARK: - Venue
struct Venue: Codable {
    let id: Int
    let name: String
    let address: String?
    let extendedAddress: String
    let url: String
    var location: String {
        if let address = address {
            return "\(address) \(extendedAddress)"
        } else { return extendedAddress }
    }
    
    enum CodingKeys: String, CodingKey {
        case extendedAddress = "extended_address"
        case id
        case name
        case address
        case url
    }
}

struct Performers: Codable {
    let name: String
    let image: String
    let type: String
    let id: Int
    let url: String
    let numUpcomingEvents: Int
    
    enum CodingKeys: String, CodingKey {
        case numUpcomingEvents = "num_upcoming_events"
        case name
        case image
        case type
        case id
        case url
    }
}
