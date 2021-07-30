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
    
    var eventFavorite: Bool {
        get {
            return UserDefaults.standard.bool(forKey: event?.shortTitle ?? "event")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: event?.shortTitle ?? "event")
        }
    }
    
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
    
    // "2021-07-28T19:30:00"
    
    func updateViews() {
        guard let event = event else { return }
        
        navTitleMultiLine(eventTitle: event.shortTitle)
        
        // DateFormatter
        let dateString = event.datetimeLocal
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObject = formatter.date(from: dateString)
        
        formatter.dateFormat = "yyyy MMM dd HH:mm a"
        eventDateTimeLabel.text = formatter.string(from: dateObject!)
        
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        getImage(with: event)
    }
    
    // Grab Image from event
    func getImage(with event: Event) {
        let imagePath = event.performers[0].image
        eventController.grabImageFromEvent(path: imagePath) { result in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.eventImageView.image = image
            }
        }
    }
    
    // Check if user tapped the favorite "heart" button
    @IBAction func favoriteButtonTapped(_ sender: Any) {
   
        if self.eventFavorite == true {
            self.eventFavorite = false
            favoriteButton.image = UIImage(systemName: "heart.fill")
            eventController.saveToPersistentStore()
        } else {
            self.eventFavorite = true
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }

}
