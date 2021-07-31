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
            updateViews()
            favoriteEventSelected()
        }
    }

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var favoriteEventImageView: UIImageView!

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let event = event else { return }
        
        eventTitleLabel.text = event.shortTitle
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        getImage(with: event)
        
        // Date Formatter
        let dateString = event.datetimeLocal
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObject = formatter.date(from: dateString)
        
        formatter.dateFormat = "yyyy MMM dd HH:mm a"
        eventDateTimeLabel.text = formatter.string(from: dateObject!)
    }
    
    func favoriteEventSelected() {
        if UserDefaults.standard.bool(forKey: event?.id.description ?? "") == true{
            favoriteEventImageView.image = UIImage(systemName: "heart.fill")
            favoriteEventImageView.tintColor = .red
        } else {
            favoriteEventImageView.image = UIImage(systemName: "")
            favoriteEventImageView.tintColor = .red
        }
    }
    
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

}
