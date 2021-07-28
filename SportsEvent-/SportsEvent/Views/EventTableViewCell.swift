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
        }
    }

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let event = event else { return }
        
        eventTitleLabel.text = event.shortTitle
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        eventDateTimeLabel.text = event.datetimeLocal
        eventImageView.image = UIImage(named: "")
    }

}
