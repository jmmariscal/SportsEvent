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
    
    let eventController = EventsController()
    
    var event: Events?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //updateViews()
    }
    
//    func updateViews() {
//        guard let event = event else { return }
//
//        eventDateTimeLabel.text = event.events.
//        eventLocationLabel.text = event.datetimeLocal
//
//
//    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
