//
//  SafeAreaInset.swift
//  LetMePass
//
//  Created by roy on 2022/4/1.
//

import SwiftUI

@available(iOS, introduced: 13, deprecated: 15, message: "Use `.safeAreaInset()` directly")
extension View {
    
    @ViewBuilder
    func verticalSafeAreaInset<OverlayContent: View>(edge: VerticalEdgeSet, spacing: CGFloat = 0, @ViewBuilder _ overlayContent: () -> OverlayContent) -> some View {
        if #available(iOS 15.0, *) {
            let aEdge: VerticalEdge = edge == .top ? .top : .bottom
            self.safeAreaInset(edge: aEdge, spacing: spacing, content: { overlayContent() })
        } else {
            switch edge {
                case .top:
                    modifier(TopInsetViewModifier(overlayContent: overlayContent()))
                    
                case .bottom:
                    modifier(BottomInsetViewModifier(overlayContent: overlayContent()))
            }
        }
    }
}

/// Needed for top inset
struct ExtraTopSafeAreaInset: View {
    @Environment(\.topSafeAreaInset) var topSafeAreaInset: CGFloat

    var body: some View {
        Spacer(minLength: topSafeAreaInset)
    }
}

/// Needed for bottom inset
struct ExtraBottomSafeAreaInset: View {
    @Environment(\.bottomSafeAreaInset) var bottomSafeAreaInset: CGFloat

    var body: some View {
        Spacer(minLength: bottomSafeAreaInset)
    }
}

@available(iOS, deprecated: 15.0, message: "You may not use this outside of `verticalSafeAreaInset` method")
enum VerticalEdgeSet {
    case top
    case bottom
}

// MARK: Implementations -

struct TopInsetViewModifier<OverlayContent: View>: ViewModifier {
    @Environment(\.topSafeAreaInset) var ancestorTopSafeAreaInset: CGFloat
    @State var overlayContentHeight: CGFloat = 0
    
    var overlayContent: OverlayContent

    func body(content: Self.Content) -> some View {
        content
            .environment(\.topSafeAreaInset, overlayContentHeight + ancestorTopSafeAreaInset)
            .overlay(
                overlayContent
                    .measureSize {
                        overlayContentHeight = $0.height
                    }
                    .padding(.top, ancestorTopSafeAreaInset),

                alignment: .top
            )
    }
}

struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
    @Environment(\.bottomSafeAreaInset) var ancestorBottomSafeAreaInset: CGFloat
    @State var overlayContentHeight: CGFloat = 0
    
    var overlayContent: OverlayContent

    func body(content: Self.Content) -> some View {
        content
            .environment(\.bottomSafeAreaInset, overlayContentHeight + ancestorBottomSafeAreaInset)
            .overlay(
                overlayContent
                    .measureSize {
                        overlayContentHeight = $0.height
                    }
                    .padding(.bottom, ancestorBottomSafeAreaInset),

                alignment: .bottom
            )
    }
}

extension EnvironmentValues {
    
    var topSafeAreaInset: CGFloat {
        get { self[TopSafeAreaInsetKey.self] }
        set { self[TopSafeAreaInsetKey.self] = newValue }
    }
    
    var bottomSafeAreaInset: CGFloat {
        get { self[BottomSafeAreaInsetKey.self] }
        set { self[BottomSafeAreaInsetKey.self] = newValue }
    }
}

struct TopSafeAreaInsetKey: EnvironmentKey {
    static var defaultValue: CGFloat = 0
}

struct BottomSafeAreaInsetKey: EnvironmentKey {
    static var defaultValue: CGFloat = 0
}
