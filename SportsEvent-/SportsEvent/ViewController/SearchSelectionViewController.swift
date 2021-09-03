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

    @IBOutlet weak var searchEventButton: UIButton!
    @IBOutlet weak var searchVenueButton: UIButton!
    @IBOutlet weak var searchPerformerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchEventButton.layer.cornerRadius     = 7
        searchVenueButton.layer.cornerRadius     = 7
        searchPerformerButton.layer.cornerRadius = 7
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchByEventSegue", let tableVC = segue.destination as? SearchResultsTableViewController {
            buttonPressed = .searchByEvent
            tableVC.buttonPressed = buttonPressed
            
        } else if segue.identifier == "searchByVenueSegue", let tableVC = segue.destination as? SearchResultsTableViewController {
            buttonPressed = .searchByVenue
            tableVC.buttonPressed = buttonPressed
        } else if segue.identifier == "searchByPerformerSegue", let tableVC = segue.destination as? SearchResultsTableViewController {
            buttonPressed = .searchByPerformers
            tableVC.buttonPressed = buttonPressed
        }
    }
    

}
