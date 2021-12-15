//
//  LocalizableStrings.swift
//  Logi LookUp
//
//  Created by Juan M Mariscal on 12/8/21.
//

import Foundation

enum Ticket {
    
    @available(iOS 15, *)
    var location: String{
        return String(localized: "Location",
                     bundle: nil,
                     comment: "Location for an Event")
    }
}
