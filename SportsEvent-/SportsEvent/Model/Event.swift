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

    enum CodingKeys: String, CodingKey {
        case shortTitle = "short_title"
        case datetimeLocal = "datetime_local"
        case venue
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.imagesTask(with: url) { images, response, error in
//     if let images = images {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Images
struct Images: Codable {
    let large, huge, small, medium: String
}

// MARK: - Venue
struct Venue: Codable {
    let city: String
    let state: String
}

struct SearchResults: Codable {
    let results: [Events]
}
