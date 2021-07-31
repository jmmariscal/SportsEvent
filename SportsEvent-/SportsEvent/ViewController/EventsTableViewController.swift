//
//  EventsTableViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var eventController = EventsController()
    var events: [Event] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let barBackgroundColor = UIColor(red: 40/255, green: 53/255, blue: 147/255, alpha: 1.0)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        searchBar.delegate = self
        navigationController?.navigationBar.barTintColor = barBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type 'EventCell' ")
        }

        let event = eventController.eventList[indexPath.row]
        cell.event = event
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let eventCell = cell as? EventTableViewCell {
//            let event = eventController.eventList[indexPath.row]
//            eventCell
//        }
//    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail", let detailVC = segue.destination as? EventDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let event = events[indexPath.row]
                detailVC.event = event
            }
        }
    }

}

extension EventsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("Search bar clicked")
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
    }
}

