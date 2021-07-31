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
    var event: Events?
    var eventList: [Event] {
        get {
            return event?.events ?? []
        }
    }
    
    var workerItem: DispatchWorkItem?
    
    private let clientID = "MTAzNzU2MTJ8MTYyNzExMzM4OS4xMDM3Mjk"
    private let baseURL = URL(string: "https://api.seatgeek.com/2/events?")!
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case pull = "PULL"
        case delete = "DELETE"
    }
    
    func searchEvent(searchTerm: String, completion: @escaping (Result<Events, NetworkError>) -> Void) {
            
            // Cancel the previous request since it is going to make another one again.
            workerItem?.cancel()
            
            self.workerItem = DispatchWorkItem(block: { [weak self] in
                
                guard let strongSelf = self else { return }
                
                var urlComponets = URLComponents(url: strongSelf.baseURL, resolvingAgainstBaseURL: true)
                let parameters = ["q": searchTerm, "client_id": strongSelf.clientID]
                let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
                    urlComponets?.queryItems = queryItems
                
                guard let requestURL = urlComponets?.url else { return }
                var request = URLRequest(url: requestURL)
                request.httpMethod = HTTPMethod.get.rawValue
                
                //request.setValue(strongSelf.clientID, forHTTPHeaderField: "client_id")
                
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
                        self?.event = try decoder.decode(Events.self, from: data)
                        completion(.success(self!.event!))
                    } catch {
                        completion(.failure(.decodeFailed))
                        print(error)
                        return
                    }
                }.resume()
                
            })
            
            // If no new text has been entered in 400 milliseconds, then it will fire off the request.
            if let dispatchWorkerItem = workerItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: dispatchWorkerItem)
            }
        }
    
    func grabImageFromEvent(path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // Build URL with necessary information
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Request Image
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
