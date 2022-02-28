//
//  NSImageExtension.swift
//
//  Created by Roy on 2021/7/28.
//

import UIKit
import SwiftUI

extension Image {
    
    func centerCropped(height: CGFloat) -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: height)
                .clipped()
        }
    }
}


extension UIImage {
    
    static func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        let renderer = UIGraphicsImageRenderer(bounds: rect)

        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fill(rect)
        }

        return img
    }
}
