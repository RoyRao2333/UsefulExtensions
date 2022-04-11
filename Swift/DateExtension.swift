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

    func component(_ component: Calendar.Component) -> Int {
        Calendar.current.component(component, from: self)
    }

    func description(style: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = style

        let daysBetween = daysBetween(date: Date())

        if daysBetween == 0 {
            return "Today".localized()
        } else if daysBetween == 1 {
            return "Yesterday".localized()
        } else if daysBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        }

        return formatter.string(from: self)
    }

    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: self)
        let endDate = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day ?? 0
    }
}
