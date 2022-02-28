//
//  ViewMeasurement.swift
//  EasyWeather
//
//  Created by roy on 2022/1/27.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    
    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size
                    )
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}
