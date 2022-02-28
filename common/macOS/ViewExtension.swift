//
//  ViewExtension.swift
//
//  Created by Roy Rao on 2021/4/12.
//

import Cocoa
import SwiftUI
import Combine

extension View {
    
    /**
     * Display your `View` conditionally.
     *
     * - Parameters:
     *      - conditional: The condition you wanna check.
     *      - ifTure: What you wanna do if checked true.
     *      - ifFalse: What you wanna do if checked false.
     */
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, yes ifTure: ((Self) -> Content)?, no ifFalse: ((Self) -> Content)?) -> some View {
        if conditional {
            if ifTure != nil {
                ifTure!(self)
            } else {
                self
            }
        } else {
            if ifFalse != nil {
                ifFalse!(self)
            } else {
                self
            }
        }
    }
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            } else {
                EmptyView()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    func isShown(_ shown: Bool, remove: Bool = false) -> some View {
        if !shown {
            if !remove {
                self.hidden()
            } else {
                EmptyView()
            }
        } else {
            self
        }
    }
    
    /// A backwards compatible wrapper for iOS 14 `onChange`.
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
    
    /**
    Applies font and color for a label used for describing a preference.
    */
    public func preferenceDescription() -> some View {
        font(.system(size: 11.0))
            // TODO: Use `.foregroundStyle` when targeting macOS 12.
            .foregroundColor(.secondary)
    }
}


extension NSView {
    
    //背景颜色
    @IBInspectable var bgColor: NSColor {
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue.cgColor
//            layer?.masksToBounds = true
        }
        
        get {
            var color = NSColor.clear
            if let cgbcolor = layer?.backgroundColor,
               let bgcolor = NSColor.init(cgColor: cgbcolor){
                color = bgcolor
            }
            return color
        }
    }
    
    /// 描边的粗细
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer?.borderWidth ?? 0
        }
        
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    /// 描边的颜色
    @IBInspectable var borderColor: NSColor? {
        get {
            if let layColor = layer?.borderColor{
              return  NSColor.init(cgColor: layColor)
            }
               
            return NSColor.clear
        }
        
        set {
            wantsLayer = true
            layer?.borderColor = newValue?.cgColor
        }
    }
    
    /// 圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return  layer?.cornerRadius ?? 0
        }
        
        set {
            wantsLayer = true
            layer?.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer?.shadowOffset ?? CGSize.zero
        }
        
        set {
            wantsLayer = true
            layer?.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer?.shadowRadius ?? 0
        }
        
        set {
            wantsLayer = true
            layer?.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer?.shadowOpacity ?? 0
        }
        
        set {
            wantsLayer = true
            layer?.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowColor: NSColor? {
        get {
            if let lScolor = layer?.shadowColor {
                return NSColor.init(cgColor: lScolor)
            }
            return NSColor.clear
        }
        
        set {
            wantsLayer = true
            layer?.shadowColor = newValue?.cgColor
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint){
        layer?.anchorPoint = anchorPoint
        if let lframe = layer?.frame{
            let xCoord = lframe.origin.x + lframe.size.width
            let yCoord = lframe.origin.y + lframe.size.height
            let cPoint = CGPoint.init(x: xCoord, y: yCoord)
            layer?.position = cPoint
        }
    }
    
    /// Shake
    func shake(count: Float = 4, for duration: TimeInterval = 0.2, withTranslation translation: Float = 3) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        self.layer?.add(animation, forKey: "shake")
    }
    
}
