//
//  SearchSelectionViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/26/21.
//

import UIKit

class SearchSelectionViewController: UIViewController {
    
    private let eventController = EventsController()
    var event: Event?
    var venue: Venue?
    var buttonPressed: SearchType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchByEventSegue", let tableVC = segue.destination as? EventsTableViewController {
            buttonPressed = .searchByEvent
            tableVC.buttonPressed = buttonPressed
            
        } else if segue.identifier == "searchByVenueSegue", let tableVC = segue.destination as? EventsTableViewController {
            buttonPressed = .searchByVenue
            tableVC.buttonPressed = buttonPressed
        }
    }
    

}
