//
//  String.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/28/21.
//

import Foundation

extension String {
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date: Date? = dateFormatter.date(from: self)
        return date
    }
}
