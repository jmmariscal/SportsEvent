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
    
    // "2021-07-28T19:30:00"
    
    func updateViews() {
        guard let event = event else { return }
        let eventDate = event.datetimeLocal
        
        navTitleMultiLine(eventTitle: event.shortTitle)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMM yyyy'T'HH:mm a"
        if let date = formatter.date(from: eventDate) {
            print(date)
        }
        
        eventLocationLabel.text = "\(event.venue.city), \(event.venue.state)"
        getImage(with: event)
    }
    
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
    var check = true
    @IBAction func favoriteButtonTapped(_ sender: Any) {
   
        if check == true {
            check = false
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            check = true
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }

}
