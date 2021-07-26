//
//  EventsController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import Foundation
import UIKit

protocol EventResultDelegate: AnyObject {
    func didGetData(results: Result<Event, NetworkError>)
}

enum NetworkError: Error {
    case unauthorized
    case noData
    case decodeFailed
    case otherError(Error)
}

class EventsController {
    var event: Event?
    weak var delegate: EventResultDelegate?
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case pull = "PULL"
        case delete = "DELETE"
    }
    
    func searchEvent(searchTerm: String) {
        let baseURL = "https://api.seatgeek.com/2/events"
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Request data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 401 {
                self.delegate?.didGetData(results: .failure(.unauthorized))
                return
            }
            
            guard error == nil else {
                self.delegate?.didGetData(results: .failure(.otherError(error!)))
                return
            }
        
            guard let data = data else {
                self.delegate?.didGetData(results: .failure(.noData))
                return
            }
            
            // Decode the data
            let decoder = JSONDecoder()
            do {
                let event = try decoder.decode(Event.self, from: data)
                self.delegate?.didGetData(results: .success(event))
            } catch {
                self.delegate?.didGetData(results: .failure(.decodeFailed))
                return
            }
        }.resume()
        
    }
    
}
