//
//  Utilities.swift
//  Stock Prices
//
//  Created by Warren Hansen on 3/18/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import Foundation

class Utilities {

    class func convertToDateFrom(string: String, debug: Bool)-> Date? {
        let formatter = DateFormatter()
        if ( debug ) { print("\ndate from is string: \(string)") }
        let dateS    = string
        formatter.dateFormat = "yyyy/MM/dd"
        let date:Date = formatter.date(from: dateS)!
        if ( debug ) { print("Convertion to Date: \(date)\n") }
        return date
    }
}
