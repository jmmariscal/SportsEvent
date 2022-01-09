//
//  LocalizableStrings.swift
//  Logi LookUp
//
//  Created by Juan M Mariscal on 12/8/21.
//

import Foundation

typealias localize = LocalizedString

public enum LocalizedString {
    enum SearchBar {
        static let searchEventPlaceHolder = NSLocalizedString("SearchBar.searchPlaceHolder",
                                                 tableName: nil,
                                                 bundle: Bundle.main,
                                                 value: "Name",
                                                 comment: "Place holder for event example text")
        static let searchVenuePlaceHolder = NSLocalizedString("SearchBar.searchVenuePlaceHolder",
                                                              tableName: nil,
                                                              bundle: Bundle.main,
                                                              value: "NameVenue",
                                                              comment: "Place holder for venue example text")
        static let searchPerformerPlaceHolder = NSLocalizedString("SearchBar.searchPerformerPlaceHolder",
                                                                  tableName: nil,
                                                                  bundle: Bundle.main,
                                                                  value: "PName",
                                                                  comment: "Place holder for performer example text")
        
    }
    
    enum SegmentController {
        static let eventTitle = NSLocalizedString("SegmentCtrl.event",
                                                  tableName: nil,
                                                  bundle: Bundle.main,
                                                  value: "Event",
                                                  comment: "Title for segmented controller")
        static let venueTitle = NSLocalizedString("SegmentCtrl.venue",
                                                  tableName: nil,
                                                  bundle: Bundle.main,
                                                  value: "Venue",
                                                  comment: "Title for segmented controller")
        static let performerTitle = NSLocalizedString("SegmentCtrl.performer",
                                                      tableName: nil,
                                                      bundle: Bundle.main,
                                                      value: "Performer",
                                                      comment: "Title for segmented controller")
    }
    
    enum FavoriteSegmentTitleCtrl {
        static let favoriteEvents = NSLocalizedString("FavoriteSgmntCtrl.event",
                                                  tableName: nil,
                                                  bundle: Bundle.main,
                                                  value: "Events",
                                                  comment: "Title for segmented controller")
        static let favoriteVenues = NSLocalizedString("FavoriteSgmntCtrl.venue",
                                                  tableName: nil,
                                                  bundle: Bundle.main,
                                                  value: "Venues",
                                                  comment: "Title for segmented controller")
        static let favoritePerformers = NSLocalizedString("FavoriteSgmntCtrl.performer",
                                                      tableName: nil,
                                                      bundle: Bundle.main,
                                                      value: "Performers",
                                                      comment: "Title for segmented controller")
    }
    
    enum Favorites {
        
    }
}
