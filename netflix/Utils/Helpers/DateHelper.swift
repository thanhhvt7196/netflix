//
//  DateHelper.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

class DateHelper {
    static func getDateString(inputFormat: String = Strings.apiDateFormat, outputFormat: String, dateString: String) -> String? {
        let dateFormatter = DateFormatter(dateFormat: inputFormat)
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
    
    static func getYear(inputFormat: String = Strings.apiDateFormat, dateString: String) -> String? {
        let dateFormatter = DateFormatter(dateFormat: inputFormat)
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return "\(Calendar.current.component(.year, from: date))"
    }
}
