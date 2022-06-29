//
//  HoverableNSButton.swift
//  EasyWeather
//
//  Created by Roy on 2021/11/23.
//

import Cocoa

class HoverableNSButton: NSButton {
    @IBInspectable var horizontalGap: CGFloat = 0
    var trackingArea: NSTrackingArea!
    var mouseDidEnter: ((HoverableNSButton) -> Void)?
    var mouseDidExit: ((HoverableNSButton) -> Void)?
    var mouseDidClick: ((HoverableNSButton) -> Void)?
    var mouseDidLoose: ((HoverableNSButton) -> Void)?
    var supportHandCursor: Bool = false {
        didSet {
            if supportHandCursor {
                cursor = .pointingHand
            }else {
                cursor = nil
            }
        }
    }
    var cursor: NSCursor?
    
    
    var didLayout: ((NSButton) -> ())?
    
    deinit {
        removeTrackingArea(trackingArea)
    }
    
    override var wantsUpdateLayer: Bool {
        true
    }
    
    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += horizontalGap * 2
        return size
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        wantsLayer = true
        trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeInKeyWindow, .mouseEnteredAndExited, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }
    
    override func updateLayer() {
        super.updateLayer()
        didLayout?(self)
    }
    
    override func layout() {
        super.layout()
        didLayout?(self)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        mouseDidEnter?(self)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        mouseDidExit?(self)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        mouseDidClick?(self)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        mouseDidLoose?(self)
    }
    
    override func resetCursorRects() {
        if supportHandCursor {
            if let cursor = cursor {
                addCursorRect(bounds, cursor: cursor)
            } else {
                super.resetCursorRects()
            }
        }
    }
}
