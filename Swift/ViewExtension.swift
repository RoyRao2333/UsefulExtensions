//
//  ViewExtension.swift
//
//  Created by Roy Rao on 2021/4/12.
//

import SwiftUI
import Combine

// MARK: SwiftUI -
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
    func `if`<Content: View>(_ conditional: Bool, if ifTure: ((Self) -> Content)?, else ifFalse: ((Self) -> Content)?) -> some View {
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

    @ViewBuilder
    func adaptedOverlay<Content: View>(alignment: Alignment = .center, @ViewBuilder content: () -> Content) -> some View {
        if #available(iOS 15.0, *) {
            self.overlay(alignment: alignment, content: content)
        } else {
            self.overlay(content(), alignment: alignment)
        }
    }
    
    /// Set if enable the scroll function in `List`s.
    func scrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
    
    /// Hide keyboard when tap outside the TextField
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
    
    func openSystemPreferences() {
        if
            let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
        {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    var screenRect: CGRect {
        UIScreen.main.bounds
    }
}


// MARK: UIKit -
#if canImport(UIKit)

import UIKit

extension UIView {
    
    /// Hide keyboard when tap outside the TextField
    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    /// Load the view from nib (xib) file.
    static func loadFromNib(bundle: Bundle? = nil) -> Self {
        let named = String(describing: Self.self)
        guard 
            let view = UINib(nibName: named, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)
                .first as? Self 
        else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        
        return view
    }

    /// 添加圆角 draw 圆角失效 UILabel 不建议使用
    /// - Parameters:
    ///   - corners: 圆角的脚边
    ///   - cornerRadius: 大小
    func addLayerCornerRadius(
        _ corners: CACornerMask = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], 
        cornerRadius: CGFloat
    ) {
        if self is UILabel {
            layer.masksToBounds = true
        }
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
    }
    
    /// View 添加 border 样式
    /// - Parameters:
    ///   - borderWidth: 宽度
    ///   - borderColor: 颜色
    func layerBorderStyles(with borderWidth: CGFloat, borderColor: UIColor?) {
        layer.borderWidth = borderWidth
        if let bColor = borderColor {
            layer.borderColor = bColor.cgColor
        }
    }

    /// 添加阴影
    func addLayerShadowPath(
        cornerRadius: CGFloat,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 2.0,
        shadowColor: UIColor = UIColor.black
    ) {
        addLayerShadowPath(
            cornerRadius: cornerRadius, 
            rect: bounds, 
            shadowOffset: shadowOffset,
            shadowOpacity: shadowOpacity, 
            shadowRadius: shadowRadius, 
            shadowColor: shadowColor,
            path: nil
        )
    }
    
    /// 添加阴影
    /// - Parameters:
    ///   - cornerRadius: 弧度
    ///   - rect: CGRect
    ///   - shadowOffset: // width -> x height -> y
    ///   - shadowOpacity: 阴影透明度
    ///   - shadowRadius: 阴影范围
    ///   - shadowColor: 颜色
    ///   - corners: 圆角
    ///   - path: 路径
    func addLayerShadowPath(
        cornerRadius: CGFloat,
        rect: CGRect,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.2,
        shadowRadius: CGFloat = 2.0,
        shadowColor: UIColor = UIColor.black,
        corners: UIRectCorner? = nil,
        path: UIBezierPath? = nil
    ) {
        let shadowPath: UIBezierPath
        if let `path` = path {
            shadowPath = path
        } else {
            if let `corners` = corners, cornerRadius != 0 {
                shadowPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            } else if cornerRadius != 0 {
                shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                shadowPath = UIBezierPath(rect: rect)
            }
        }
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
    }
}

#endif
