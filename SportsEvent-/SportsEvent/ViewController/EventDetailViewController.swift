//
//  EventDetailViewController.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/25/21.
//

import UIKit

enum SFSymbols {
    static let filledHeart = UIImage(systemName: "heart.fill")
    static let heart       = UIImage(systemName: "heart")
    static let trash       = UIImage(systemName: "trash.fill")
    static let noImage     = UIImage(systemName: "")
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    let eventController = EventsController()
    var event: Event?
    let userDefaults = UserDefaults.standard
    let favoriteEvents = FavoriteEventsViewController()
    var favoriteButtonVissible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            favoriteButton.image     = SFSymbols.filledHeart
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.image     = SFSymbols.heart
            favoriteButton.tintColor = .red
        }
        
        if favoriteButtonVissible == true {
            favoriteButton.image     = SFSymbols.trash
            favoriteButton.tintColor = .white
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
        guard let event = event else { return }

        if favoriteButton.image == SFSymbols.filledHeart {
            userDefaults.set(false, forKey: event.id.description)
            favoriteButton.image = SFSymbols.heart
            
        } else if favoriteButton.image == SFSymbols.heart {
            userDefaults.set(true, forKey: event.id.description)
            eventController.favoriteList.append(event)
            eventController.saveToPersistentStore()
            favoriteButton.image = SFSymbols.filledHeart
            
        } else if favoriteButton.image == SFSymbols.trash {
            userDefaults.set(false, forKey: event.id.description)
            eventController.deleteFromPersistentStore()
            favoriteButton.image = SFSymbols.noImage
            favoriteButton.isEnabled = false
        }
    }

}
