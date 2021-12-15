//
//  EventDetailViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import UIKit

enum SFSymbols {
    static let filledHeart  = UIImage(systemName: "heart.fill")
    static let heart        = UIImage(systemName: "heart")
    static let trash        = UIImage(systemName: "trash.fill")
    static let trashSlashed = UIImage(systemName: "trash.slash")
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var eventController: EventsController!
    var event: Event?
    var venue: Venue?
    var performer: Performers?
    var buttonPressed: SearchType?
    let userDefaults = UserDefaults.standard
    var trashButtonEnabled: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch buttonPressed {
        case .searchByEvent:
            updateEventDetail()
        case .searchByVenue:
            updateVenueDetail()
        case .searchByPerformers:
            updatePerformerDetail()
        default:
            print("Error: Unable to Update Detail UI")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch buttonPressed {
        case .searchByEvent:
            updateEventDetail()
        case .searchByVenue:
            updateVenueDetail()
        case .searchByPerformers:
            updatePerformerDetail()
        default:
            print("Error: Unable to Update Detail UI")
        }
    }
    
    func navTitleMultiLine(eventTitle: String) {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines   = 2
        label.font            = UIFont.boldSystemFont(ofSize: 15.0)
        label.textAlignment   = .left
        label.text            = eventTitle
        self.navigationItem.titleView = label
    }
        
    func updateEventDetail() {
        guard let event = event else { return }
        navTitleMultiLine(eventTitle: event.shortTitle)
        
        eventDateTimeLabel.text = event.datetimeLocal.datePresentationFormat
        
        eventLocationLabel.text = event.venue.location
        getEventImage(with: event)
        
        if userDefaults.bool(forKey: event.id.description) == true {
            favoriteButton.image     = SFSymbols.filledHeart
            favoriteButton.tintColor = .red
        } else if userDefaults.bool(forKey: event.id.description) == true {
            favoriteButton.image     = SFSymbols.heart
            favoriteButton.tintColor = .red
        }
        
        if trashButtonEnabled == true {
            favoriteButton.image     = SFSymbols.trash
            favoriteButton.tintColor = .black
        }
    }
    
    func updateVenueDetail() {
        guard let venue = venue else { return }
        navTitleMultiLine(eventTitle: venue.name)
        
        eventLocationLabel.text = venue.location
        eventDateTimeLabel.text = ""
        
        if userDefaults.bool(forKey: venue.id.description) == true {
            favoriteButton.image     = SFSymbols.filledHeart
            favoriteButton.tintColor = .red
        } else if userDefaults.bool(forKey: venue.id.description) == true {
            favoriteButton.image     = SFSymbols.heart
            favoriteButton.tintColor = .red
        }
        
        if trashButtonEnabled == true {
            favoriteButton.image     = SFSymbols.trash
            favoriteButton.tintColor = .black
        }
    }
    
    func updatePerformerDetail() {
        guard let performer = performer else { return }
        navTitleMultiLine(eventTitle: performer.name)
        eventDateTimeLabel.text = performer.type.capitalized
        eventLocationLabel.text = ""
        getPerformerImage(with: performer)
        
        if userDefaults.bool(forKey: performer.id.description) == true {
            favoriteButton.image    = SFSymbols.filledHeart
            favoriteButton.tintColor = .red
        } else if userDefaults.bool(forKey: performer.id.description) == true {
            favoriteButton.image    = SFSymbols.heart
            favoriteButton.tintColor = .red
        }
        
        if trashButtonEnabled == true {
            favoriteButton.image     = SFSymbols.trash
            favoriteButton.tintColor = .black
        }
    }
    
    // Grab Image from network call
    func getEventImage(with event: Event) {
        let imagePath = event.performers[0].image
        eventController.grabImageFromNetwork(path: imagePath) { result in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.eventImageView.layer.cornerRadius = 7
                self.eventImageView.image = image
            }
        }
    }
    
    func getPerformerImage(with performer: Performers) {
        let imagePath = performer.image
        eventController.grabImageFromNetwork(path: imagePath) { result in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.eventImageView.layer.cornerRadius = 7
                self.eventImageView.image = image
            }
        }
    }
    
    
    // Check if user tapped the favorite "heart" button
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        switch buttonPressed {
        
        case .searchByEvent:
            handleFavoriteEvent()
        case .searchByVenue:
            handleFavoriteVenue()
        case .searchByPerformers:
            handleFavoritePerformer()
        default:
            print("Error: Could Not Favorite Cell")
        }

    }
    
    // If user taps on favorite button, save and persist. If user unfavorites, remove from persistence and from favorite list
    func handleFavoriteEvent() {
        guard let event = event else { return }

        if favoriteButton.image == SFSymbols.filledHeart {
            userDefaults.set(false, forKey: event.id.description)
            eventController.removeEventFromFavoriteList(id: event.id)
            favoriteButton.image = SFSymbols.heart
            
        } else if favoriteButton.image == SFSymbols.heart {
            userDefaults.set(true, forKey: event.id.description)
            eventController.favoriteEventList.append(event)
            eventController.saveEventToPersistentStore()
            favoriteButton.image = SFSymbols.filledHeart
            
        } else if favoriteButton.image == SFSymbols.trash {
            userDefaults.set(false, forKey: event.id.description)
            eventController.removeEventFromFavoriteList(id: event.id)
            favoriteButton.image = SFSymbols.trashSlashed
            favoriteButton.isEnabled = false
        }
    }
    
    func handleFavoriteVenue() {
        guard let venue = venue else { return }

        if favoriteButton.image == SFSymbols.filledHeart {
            userDefaults.set(false, forKey: venue.id.description)
            eventController.removeVenueFromFavoriteList(id: venue.id)
            favoriteButton.image = SFSymbols.heart
            
        } else if favoriteButton.image == SFSymbols.heart {
            userDefaults.set(true, forKey: venue.id.description)
            eventController.favoriteVenueList.append(venue)
            eventController.saveVenueToPersistentStore()
            favoriteButton.image = SFSymbols.filledHeart
            
        } else if favoriteButton.image == SFSymbols.trash {
            userDefaults.set(false, forKey: venue.id.description)
            eventController.removeVenueFromFavoriteList(id: venue.id)
            favoriteButton.image = SFSymbols.trashSlashed
            favoriteButton.isEnabled = false
        }
    }
    
    func handleFavoritePerformer() {
        guard let performer = performer else { return }
        
        if favoriteButton.image == SFSymbols.filledHeart {
            userDefaults.set(false, forKey: performer.id.description)
            eventController.removePerformerFromFavoriteList(id: performer.id)
            favoriteButton.image = SFSymbols.heart
            
        } else if favoriteButton.image == SFSymbols.heart {
            userDefaults.set(true, forKey: performer.id.description)
            eventController.favoritePerformerList.append(performer)
            eventController.savePerformerToPersistentStore()
            favoriteButton.image = SFSymbols.filledHeart
            
        } else if favoriteButton.image == SFSymbols.trash {
            userDefaults.set(false, forKey: performer.id.description)
            eventController.removePerformerFromFavoriteList(id: performer.id)
            favoriteButton.image = SFSymbols.trashSlashed
            favoriteButton.isEnabled = false
        }
    }

}
