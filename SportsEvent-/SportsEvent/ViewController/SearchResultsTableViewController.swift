//
//  SearchResultsTableViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    var buttonPressed: SearchType?
    var eventController = EventsController()
    
    var events: [Event] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var venues: [Venue] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var performers: [Performers] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch buttonPressed {
        case .searchByEvent:
            return events.count
        case .searchByVenue:
            return venues.count
        case .searchByPerformers:
            return performers.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type 'EventCell' ")
        }
        switch buttonPressed {
        case .searchByEvent:
            let event = events[indexPath.row]
            cell.event = event
        case .searchByVenue:
            let venue = venues[indexPath.row]
            cell.venue = venue
        case .searchByPerformers:
            let performer = performers[indexPath.row]
            cell.performer = performer
        default:
            print("No Button was selected, no Cell available")
        }
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail", let detailVC = segue.destination as? EventDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            detailVC.eventController = self.eventController
            
            switch buttonPressed {
            case .searchByEvent:
                let events = events[indexPath.row]
                detailVC.buttonPressed = .searchByEvent
                detailVC.event = events
            case .searchByVenue:
                let venues = venues[indexPath.row]
                detailVC.venue = venues
                detailVC.buttonPressed = .searchByVenue
            case .searchByPerformers:
                let performers = performers[indexPath.row]
                detailVC.buttonPressed = .searchByPerformers
                detailVC.performer = performers
            default:
                print("Error: Could not segue to DetailVC")
            }
        }
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Search while User is typing in Search Bar
        switch buttonPressed {
        case .searchByEvent:
            eventController.searchEvent(searchTerm: searchText) { result in
                do {
                    let events = try result.get()
                    DispatchQueue.main.async { [weak self] in
                        self?.events = events.events
                    }
                } catch {
                    print("\(error)")
                    return
                }
            }
        case .searchByVenue:
            eventController.searchVenue(searchTerm: searchText) { result in
                do {
                    let venues = try result.get()
                    DispatchQueue.main.async { [weak self] in
                        self?.venues = venues.venues
                    }
                } catch {
                    print("\(error)")
                    return
                }
            }
        case .searchByPerformers:
            eventController.searchPerformers(searchTerm: searchText) { result in
                do {
                    let performers = try result.get()
                    DispatchQueue.main.async { [weak self] in
                        self?.performers = performers.performers
                    }
                } catch {
                    print("\(error)")
                    return
                }
            }
        default:
            return
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

