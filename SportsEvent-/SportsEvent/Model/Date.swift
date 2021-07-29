//
//  Date.swift
//  SportsEvent
//
//  Created by Juan M Mariscal on 7/28/21.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
