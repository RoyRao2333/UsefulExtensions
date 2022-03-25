//
//  NumberOnlyTextField.swift
//
//  Created by roy on 2022/2/24.
//

import SwiftUI

struct NumberOnlyTextField: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
            .onChange(of: text) { newValue in
                let periodCount = newValue.components(separatedBy: ".").count - 1
                let commaCount = newValue.components(separatedBy: ",").count - 1
                
                if newValue.last == "." && periodCount > 1 || newValue.last == "," && commaCount > 1 {
                    //it's a second period or comma, remove it
                    text = String(newValue.dropLast())
                    // as bonus for the user, add haptic effect
                    let generator = UINotificationFeedbackGenerator()
                    generator.prepare()
                    generator.notificationOccurred(.warning)
                } else {
                    let filtered = newValue.filter { "0123456789.,".contains($0) }
                    if filtered != newValue {
                        text = filtered
                    }
                }
            }
    }
}
