//
//  EventTableViewCell.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/23/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var eventController = EventsController()
    var event: Events? {
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
        eventTitleLabel.text = event?.events[0].shortTitle
        eventLocationLabel.text = event?.events[0].venue.city
        eventDateTimeLabel.text = event?.events[0].datetimeLocal
        eventImageView.image = UIImage(named: "")
    }

}
