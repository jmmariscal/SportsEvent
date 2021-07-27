//
//  EventsController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import Foundation
import UIKit


enum NetworkError: Error {
    case unauthorized
    case noData
    case decodeFailed
    case otherError(Error)
}

class EventsController {
    var event: Event?
    var eventList: [Event] = []
    
    private let clientID = "MTAzNzU2MTJ8MTYyNzExMzM4OS4xMDM3Mjk"
    private let baseURL = URL(string: "https://api.seatgeek.com/2/events?")!
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case pull = "PULL"
        case delete = "DELETE"
    }
    
    func searchEvent(searchTerm: String, completion: @escaping (Result<Event, NetworkError>) -> Void) {
        
        var urlComponets = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let parameters = ["q=": searchTerm]
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponets?.queryItems = queryItems
        
        guard let requestURL = urlComponets?.url else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue(clientID, forHTTPHeaderField: "&client_id=")
        
        // Request data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 401 {
                completion(.failure(.unauthorized))
                return
            }
            
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
        
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Decode the data
            let decoder = JSONDecoder()
            do {
                let event = try decoder.decode(Event.self, from: data)
                completion(.success(event))
            } catch {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
        
    }
    
}
