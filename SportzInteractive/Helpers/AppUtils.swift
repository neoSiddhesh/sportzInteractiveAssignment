//
//  AppUtils.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import Foundation

class AppUtils {
    
    private init() {}
    
    static func convertDateToString(date: String, currentFormat: String = "MM/dd/yyyy", requiredFormat: String = "dd MMM, yyyy") -> String {
        
        let formatter = DateFormatter()
        var formattedDate: Date!
        
        if date == "" {
            return "NA"
        } else {
            formatter.dateFormat = currentFormat
            formattedDate = formatter.date(from: date) ?? Date()
        }
        
        formatter.dateFormat = requiredFormat
        let dateStr = formatter.string(from: formattedDate)
        return dateStr
    }
}
