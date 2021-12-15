//
//  EventTableViewCell.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var eventController = EventsController()
    var event: Event? {
        didSet {
            updateEventViews()
            favoriteEventSelected()
        }
    }
    var venue: Venue? {
        didSet{
            updateVenueViews()
            favoriteEventSelected()
        }
    }
    var performer: Performers? {
        didSet{
            updatePerformerViews()
            favoriteEventSelected()
        }
    }
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var favoriteEventImageView: UIImageView!
    
    private func updateEventViews() {
        guard let event = event else { return }
        
        eventTitleLabel.text    = event.shortTitle
        eventLocationLabel.text = event.venue.location
        eventDateTimeLabel.text = event.datetimeLocal.datePresentationFormat
        getEventImage(with: event)
    }
    
    private func updateVenueViews() {
        guard let venue = venue else { return }

        eventTitleLabel.text    = venue.name
        eventLocationLabel.text = venue.location
        eventImageView.image    = UIImage(named: "")
    }
    
    private func updatePerformerViews() {
        guard let performer = performer else { return }
        
        eventTitleLabel.text    = performer.name
        eventLocationLabel.text = ""
        eventDateTimeLabel.text = performer.type.capitalized
        getPerformerImage(with: performer)
    }
    
    // Check if user selected event as Favorite
    func favoriteEventSelected() {
        if userDefaults.bool(forKey: event?.id.description ?? "") == true {
            favoriteEventImageView.image     = SFSymbols.filledHeart
            favoriteEventImageView.tintColor = .red
        } else if userDefaults.bool(forKey: venue?.id.description ?? "")  == true {
            favoriteEventImageView.image     = SFSymbols.filledHeart
            favoriteEventImageView.tintColor = .red
        } else if userDefaults.bool(forKey: performer?.id.description ?? "") == true {
            favoriteEventImageView.image     = SFSymbols.filledHeart
            favoriteEventImageView.tintColor = .red
        } else {
            favoriteEventImageView.image     = UIImage(systemName: "")
            favoriteEventImageView.tintColor = .red
        }
    }
    
    // Grab Image of event
    func getEventImage(with event: Event) {
        
        let imagePath = event.performers[0].image
        
        eventController.grabImageFromNetwork(path: imagePath) { result in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.eventImageView.layer.cornerRadius = 10
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

}
