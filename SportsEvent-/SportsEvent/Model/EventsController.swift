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
    func searchVenue(searchTerm: String, completion: @escaping (Result<Venues, NetworkError>) -> Void)
    func searchPerformers(searchTerm: String, completion: @escaping (Result<Performer, NetworkError>) -> Void)
    func grabImageFromEvent(path: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    var event: Events? { get }
    var venue: Venues? { get }
    var performer: Performer? { get }
}

enum NetworkError: Error {
    case unauthorized
    case noData
    case decodeFailed
    case otherError(Error)
}

class EventsController: EventsNetworkManager {
    
    var event: Events?
    var venue: Venues?
    var performer: Performer?
    
    var favoriteEventList: [Event] = []
    var favoriteVenueList: [Venue] = []
    var favoritePerformerList: [Performers] = []
    var workerItem: DispatchWorkItem?
    
    init() {
        loadEventFromPersistentStore()
        loadVenueFromPersistentStore()
    }
    
    private let clientID          = "MTAzNzU2MTJ8MTYyNzExMzM4OS4xMDM3Mjk"
    private let eventBaseURL      = URL(string: "https://api.seatgeek.com/2/events?")!
    private let venueBaseURL      = URL(string: "https://api.seatgeek.com/2/venues?")!
    private let performersBaseURL = URL(string: "https://api.seatgeek.com/2/performers?")!
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case pull   = "PULL"
        case delete = "DELETE"
    }
    
    func generateEventSearchTermRequest(searchTerm: String) -> URLRequest {
        
        var urlComponets = URLComponents(url: eventBaseURL, resolvingAgainstBaseURL: true)
        let parameters   = ["q": searchTerm, "client_id": clientID]
        let queryItems   = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponets?.queryItems = queryItems
        
        let requestURL = urlComponets!.url!
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    func generateVenueSearchTermRequest(searchTerm: String) -> URLRequest {
        var urlComponents = URLComponents(url: venueBaseURL, resolvingAgainstBaseURL: true)
        let parameters    = ["q": searchTerm, "client_id": clientID]
        let queryItems    = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value)}
        urlComponents?.queryItems = queryItems
        
        let requestURL = urlComponents!.url!
        var request    = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    func generatePerformersSearchTermRequest(searchTerm: String) -> URLRequest {
        var urlComponents = URLComponents(url: performersBaseURL, resolvingAgainstBaseURL: true)
        let parameters    = ["q": searchTerm, "client_id": clientID]
        let queryItems    = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value)}
        urlComponents?.queryItems = queryItems
        
        let requestURL = urlComponents!.url!
        var request    = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    func searchEvent(searchTerm: String, completion: @escaping (Result<Events, NetworkError>) -> Void) {
            
            // Cancel the previous request since it is going to make another one again.
            workerItem?.cancel()
            
            self.workerItem = DispatchWorkItem(block: { [weak self] in
                
                guard let strongSelf = self else { return }
                
                let request = strongSelf.generateEventSearchTermRequest(searchTerm: searchTerm)
                                
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
                    decoder.dateDecodingStrategy = .iso8601
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
    
    func searchVenue(searchTerm: String, completion: @escaping (Result<Venues, NetworkError>) -> Void) {
        
        // Cancel the previous request since it is going to make another one again.
        workerItem?.cancel()
        
        self.workerItem = DispatchWorkItem(block: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            let request = strongSelf.generateVenueSearchTermRequest(searchTerm: searchTerm)
                            
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
                    strongSelf.venue = try decoder.decode(Venues.self, from: data)
                    completion(.success(self!.venue!))
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
    
    func searchPerformers(searchTerm: String, completion: @escaping (Result<Performer, NetworkError>) -> Void) {
        // Cancel the previous request since it is going to make another one again.
        workerItem?.cancel()
        
        self.workerItem = DispatchWorkItem(block: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            let request = strongSelf.generatePerformersSearchTermRequest(searchTerm: searchTerm)
                            
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
                    strongSelf.performer = try decoder.decode(Performer.self, from: data)
                    completion(.success(self!.performer!))
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
    // Load from Persistent Store the event, venue, performer
    func loadEventFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = eventURL, fileManager.fileExists(atPath: url.path) else {
            favoriteEventList = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            self.favoriteEventList = try decoder.decode([Event].self, from: data)
        } catch {
            print("error loading event data: \(error)")
        }
    }
    
    func loadVenueFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = venueURL, fileManager.fileExists(atPath: url.path) else {
            favoriteVenueList = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            self.favoriteVenueList = try decoder.decode([Venue].self, from: data)
        } catch {
            print("error loading event data: \(error)")
        }
    }
    
    func loadPerformerFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = performerURL, fileManager.fileExists(atPath: url.path) else {
            favoritePerformerList = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            self.favoritePerformerList = try decoder.decode([Performers].self, from: data)
        } catch {
            print("Error loading event data: \(error)")
        }
    }
    
    // Save to Persistent Store the event, venue or performer
    func saveEventToPersistentStore() {
        guard let eventUrl = eventURL else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(favoriteEventList)
            try data.write(to: eventUrl)
        } catch {
            print("Error saving event data: \(error)")
        }
    }
    
    func saveVenueToPersistentStore() {
        guard let venueUrl = venueURL else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(favoriteVenueList)
            try data.write(to: venueUrl)
        } catch {
            print("Error saving venue data: \(error)")
        }
    }
    
    func savePerformerToPersistentStore() {
        guard let performerUrl = performerURL else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(favoritePerformerList)
            try data.write(to: performerUrl)
        } catch {
            print("Error saving performer data: \(error)")
        }
    }
    
    // Remove from persistent store the event or venue
    func removeEventFromFavoriteList(id: Int) {
        guard let index = favoriteEventList.firstIndex(where: { $0.id == id }) else { return }
        favoriteEventList.remove(at: index)
        saveEventToPersistentStore()
    }
    
    func removeVenueFromFavoriteList(id: Int) {
        guard let index = favoriteVenueList.firstIndex(where: { $0.id == id }) else { return }
        favoriteVenueList.remove(at: index)
        saveVenueToPersistentStore()
    }

    private var eventURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "event.plist"
        
        return documentDirectory?.appendingPathComponent(fileName)
    }
    
    private var venueURL: URL? {
        let docuemntDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "venue.plist"
        
        return docuemntDirectory?.appendingPathComponent(fileName)
    }
    
    private var performerURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "performer.plist"
        
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
