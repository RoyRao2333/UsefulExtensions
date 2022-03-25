//
//  NumberExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/10/28.
//

import Foundation

extension Int {
    
    var chinese: String? {
        let userLocale = Locale(identifier: "zh_Hans_CN")
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = userLocale
        
        return formatter.string(for: self)
    }
}


extension Double {
    
    var chinese: String? {
        let userLocale = Locale(identifier: "zh_Hans_CN")
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = userLocale
        
        return formatter.string(for: self)
    }
    
    //Rounds the double to decimal places value
    func roundTo(_ places: Int) -> Double {
        
        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }
}
