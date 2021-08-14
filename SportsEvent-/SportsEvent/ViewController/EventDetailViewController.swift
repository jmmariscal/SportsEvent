//
//  EventDetailViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    let eventController = EventsController()
    var event: Event?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func navTitleMultiLine(eventTitle: String) {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = eventTitle
        self.navigationItem.titleView = label
    }
        
    func updateViews() {
        guard let event = event else { return }
        
        navTitleMultiLine(eventTitle: event.shortTitle)
        
        eventDateTimeLabel.text = event.datetimeLocal.datePresentationFormat
        
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        getImage(with: event)
        
        if userDefaults.bool(forKey: event.id.description) == true{
            favoriteButton.image = UIImage(systemName: "heart.fill")
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
            favoriteButton.tintColor = .red
        }
    }
    
    // Grab Image from event
    func getImage(with event: Event) {
        let imagePath = event.performers[0].image
        eventController.grabImageFromEvent(path: imagePath) { result in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.eventImageView.layer.cornerRadius = 10
                self.eventImageView.image = image
            }
        }
    }
    
    
    // Check if user tapped the favorite "heart" button
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let eventKey = event?.id.description else { return }

        if favoriteButton.image == UIImage(systemName: "heart.fill") {
            userDefaults.set(false, forKey: eventKey)
            favoriteButton.image = UIImage(systemName: "heart")
        } else if favoriteButton.image == UIImage(systemName: "heart") {
            userDefaults.set(true, forKey: eventKey)
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
    }

}
