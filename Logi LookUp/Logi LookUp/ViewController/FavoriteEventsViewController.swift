//
//  FavoriteEventsViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/18/21.
//

import UIKit

class FavoriteEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    
    let eventController = EventsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setupSegmentControllerTitles()
        eventController.loadEventFromPersistentStore()
        eventController.loadVenueFromPersistentStore()
        eventController.loadPerformerFromPersistentStore()
        tableView.reloadData()
        navigationItem.title = localize.Favorites.favoritesTitle
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventController.loadEventFromPersistentStore()
        eventController.loadVenueFromPersistentStore()
        eventController.loadPerformerFromPersistentStore()
        tableView.reloadData()
    }
    
    @IBAction func selectedSegment(_ sender: Any) {
        tableView.reloadData()
    }
    
    func setupSegmentControllerTitles() {
        favoritesSegmentedControl.setTitle(localize.FavoriteSegmentTitleCtrl.favoriteEvents, forSegmentAt: 0)
        favoritesSegmentedControl.setTitle(localize.FavoriteSegmentTitleCtrl.favoriteVenues, forSegmentAt: 1)
        favoritesSegmentedControl.setTitle(localize.FavoriteSegmentTitleCtrl.favoritePerformers, forSegmentAt: 2)
    }
    
}

extension FavoriteEventsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch favoritesSegmentedControl.selectedSegmentIndex {
        case 0:
            return eventController.favoriteEventList.count
        case 1:
            return eventController.favoriteVenueList.count
        case 2:
            return eventController.favoritePerformerList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteEventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type FavoriteEventCell")
        }
        switch favoritesSegmentedControl.selectedSegmentIndex {
        case 0:
            let event = eventController.favoriteEventList[indexPath.row]
            cell.event = event
            return cell
        case 1:
            let venue = eventController.favoriteVenueList[indexPath.row]
            cell.venue = venue
            return cell
        case 2:
            let performer = eventController.favoritePerformerList[indexPath.row]
            cell.performer = performer
            return cell
        default:
            print("Error: Could DequeReusable Cell")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch favoritesSegmentedControl.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "showEventDetailSegue", sender: self)
        case 1:
            self.performSegue(withIdentifier: "showVenueDetailSegue", sender: self)
        case 2:
            self.performSegue(withIdentifier: "showPerformerDetailSegue", sender: self)
        default:
            return
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetailSegue", let detailVC = segue.destination as? EventDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let event = eventController.favoriteEventList[indexPath.row]
                detailVC.eventController = self.eventController
                detailVC.event = event
                detailVC.trashButtonEnabled = true
                detailVC.buttonPressed = .searchByEvent
            }
        } else if segue.identifier == "showVenueDetailSegue", let detailVC = segue.destination as? EventDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let venue = eventController.favoriteVenueList[indexPath.row]
                detailVC.eventController = self.eventController
                detailVC.venue = venue
                detailVC.trashButtonEnabled = true
                detailVC.buttonPressed = .searchByVenue
            }
        } else if segue.identifier == "showPerformerDetailSegue", let detailVC = segue.destination as? EventDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let performer = eventController.favoritePerformerList[indexPath.row]
                detailVC.eventController = self.eventController
                detailVC.performer = performer
                detailVC.trashButtonEnabled = true
                detailVC.buttonPressed = .searchByPerformers
            }
        }
    }
}
