//
//  DateExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/11/8.
//

import Foundation

extension Date {
    
    func formatted(_ format: String = "MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
