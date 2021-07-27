//
//  EventsTableViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var eventController = EventsController()
    var events: Events?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        searchBar.delegate = self
    
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.eventList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type 'EventCell' ")
        }

        let event = eventController.eventList[indexPath.row]
        cell.event = event
        return cell
    }
    


    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let detailVC = segue.destination as! EventDetailViewController
            //detailVC.event = self.events[indexPath.row]
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
                    self.events = events
                    
                }
            } catch {
                print("\(error)")
                return
            }
        }
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        guard let searchTerm = searchBar.text, searchTerm != "" else { return }
//        print("Search bar clicked")
//        eventController.searchEvent(searchTerm: searchTerm) { (result) in
//            do {
//                let events = try result.get()
//                DispatchQueue.main.async {
//                    self.events = events
//
//                }
//            } catch {
//                print("\(error)")
//                return
//            }
//        }
//    }
    
    
}

