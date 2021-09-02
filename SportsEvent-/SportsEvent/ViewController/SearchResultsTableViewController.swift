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
        if events.count <= 0 {
            return venues.count
        } else {
            return events.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type 'EventCell' ")
        }
        if events.count <= 0 {
            let venue = venues[indexPath.row]
            cell.venue = venue
        } else {
            let event = events[indexPath.row]
            cell.event = event
        }

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail", let detailVC = segue.destination as? EventDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            detailVC.eventController = self.eventController
            if events.count <= 0 {
                let venues = venues[indexPath.row]
                detailVC.venue = venues
                detailVC.buttonPressed = buttonPressed
            } else {
                let events = events[indexPath.row]
                detailVC.buttonPressed = buttonPressed
                detailVC.event = events
                detailVC.selectedFavoriteEventSegue = true
            }
        }
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Search for events while User is typing in Search Bar
        switch buttonPressed {
        case .searchByEvent:
            eventController.searchEvent(searchTerm: searchText) { (result) in
                do {
                    let events = try result.get()
                    DispatchQueue.main.async {
                        self.events = events.events
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
                    DispatchQueue.main.async {
                        self.venues = venues.venues
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

