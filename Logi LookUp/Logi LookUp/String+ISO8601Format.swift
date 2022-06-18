//
//  String+ISO8601Format.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 8/13/21.
//

import Foundation

extension String {
    
    var datePresentationFormat: String?{
        // Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObject = formatter.date(from: self)
        
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return dateObject.flatMap(formatter.string(from:))
    }
}
