//
//  FavoriteEventsViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/18/21.
//

import UIKit

class FavoriteEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let eventController = EventsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension FavoriteEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteEventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Can't deque cell of type FavoriteEventCell")
        }
        
        let event = eventController.favoriteList[indexPath.row]
        cell.event = event
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteEventDetailSegue", let detailVC = segue.destination as? EventDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let event = eventController.favoriteList[indexPath.row]
                detailVC.event = event
                detailVC.favoriteButtonVissible = true
            }
        }
    }
}
