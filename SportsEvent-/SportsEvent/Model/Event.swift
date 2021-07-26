//
//  Event.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//
import Foundation

// MARK: - Events
struct Event: Codable {
    let title: String
    let datetimeLocal: String
    let venue: Venue

    enum CodingKeys: String, CodingKey {
        case title
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


// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            //completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func eventsTask(with url: URL, completionHandler: @escaping (Events?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
