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

    enum CodingKeys: String, CodingKey {
        case shortTitle = "short_title"
        case datetimeLocal = "datetime_local"
        case venue
        case performers
        case id
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
    }
}

struct Performers: Codable {
    let name: String
    let image: String
    let type: String
    let id: Int
}
