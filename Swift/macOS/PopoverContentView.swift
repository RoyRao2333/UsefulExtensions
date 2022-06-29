//
//  PopoverContentView.swift
//  EasyWeather
//
//  Created by Roy on 2021/11/18.
//

import Cocoa

class PopoverContentView: NSView {
    private var backgroundView: PopoverBackgroundView?
    
    override var bgColor: NSColor {
        didSet {
            backgroundView?.bgColor = bgColor
        }
    }
    
//    override var isFlipped: Bool { true }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        if
            let contentView = self.window?.contentView?.superview,
            backgroundView == nil
        {
            backgroundView = PopoverBackgroundView(frame: contentView.bounds)
            backgroundView?.bgColor = bgColor
            backgroundView?.autoresizingMask = [.width, .height]
            contentView.addSubview(backgroundView!, positioned: .below, relativeTo: contentView)
        }
    }
}


fileprivate class PopoverBackgroundView: NSView {
    
    override var bgColor: NSColor {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        bgColor.set()
        bounds.fill()
    }
}
