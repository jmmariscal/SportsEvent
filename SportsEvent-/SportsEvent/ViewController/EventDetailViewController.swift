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
        
        // DateFormatter
        let dateString = event.datetimeLocal
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObject = formatter.date(from: dateString)
        
        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm a"
        eventDateTimeLabel.text = formatter.string(from: dateObject!)
        
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        getImage(with: event)
        
        if UserDefaults.standard.bool(forKey: event.id.description) == true{
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
            UserDefaults.standard.set(false, forKey: eventKey)
            favoriteButton.image = UIImage(systemName: "heart")
        } else if favoriteButton.image == UIImage(systemName: "heart") {
            UserDefaults.standard.set(true, forKey: eventKey)
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
    }

}
