//
//  AnimationExtension.swift
//  EasyWeather
//
//  Created by Roy Rao on 2022/6/28.
//

import SwiftUI

extension AnyTransition {
    
    static var reverseSlide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
}
