//
//  EventsController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import Foundation
import UIKit

protocol EventsNetworkManager {
    func searchEvent(searchTerm: String, completion: @escaping (Result<Events, NetworkError>) -> Void)
    func grabImageFromEvent(path: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    var event: Events? { get }
}

enum NetworkError: Error {
    case unauthorized
    case noData
    case decodeFailed
    case otherError(Error)
}

class EventsController: EventsNetworkManager {
    var event: Events?
    
    var favoriteList: [Event] = []
    var workerItem: DispatchWorkItem?
    
    init() {
        loadFromPersistentStore()
    }
    
    private let clientID = "MTAzNzU2MTJ8MTYyNzExMzM4OS4xMDM3Mjk"
    private let baseURL  = URL(string: "https://api.seatgeek.com/2/events?")!
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case pull   = "PULL"
        case delete = "DELETE"
    }
    
    func generateSearchTermRequest(searchTerm: String) -> URLRequest {
        
        var urlComponets = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let parameters = ["q": searchTerm, "client_id": clientID]
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponets?.queryItems = queryItems
        
        let requestURL = urlComponets!.url!
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    func searchEvent(searchTerm: String, completion: @escaping (Result<Events, NetworkError>) -> Void) {
            
            // Cancel the previous request since it is going to make another one again.
            workerItem?.cancel()
            
            self.workerItem = DispatchWorkItem(block: { [weak self] in
                
                guard let strongSelf = self else { return }
                
                let request = strongSelf.generateSearchTermRequest(searchTerm: searchTerm)
                                
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
                        strongSelf.event = try decoder.decode(Events.self, from: data)
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
    
    // MARK: - Persistence
    
    func loadFromPersistentStore() {
        
        // Plist -> Data -> Stars
        let fileManager = FileManager.default
        guard let url = eventURL, fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            self.favoriteList = try decoder.decode([Event].self, from: data)
        } catch {
            print("error loading event data: \(error)")
        }
    }
    
    func saveToPersistentStore() {
        
        guard let url = eventURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(favoriteList)
            try data.write(to: url)
        } catch {
            print("Error saving event data: \(error)")
        }
    }
    
    func deleteFromPersistentStore() {
        guard let url = eventURL, FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private var eventURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "event.plist"
        
        return documentDirectory?.appendingPathComponent(fileName)
    }
}

extension EventsNetworkManager {
    var eventList: [Event] {
        get {
            return event?.events ?? []
        }
    }
}
