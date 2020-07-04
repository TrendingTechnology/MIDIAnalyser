//
//  HyperlinkTextField.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 13/02/2020.
//  Copyright © 2020 AudioKit. All rights reserved.
//

// https://stackoverflow.com/questions/38340282/simple-clickable-link-in-cocoa-and-swift

import Cocoa

@IBDesignable
class HyperlinkTextField: NSTextField {
    @IBInspectable var href: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: NSColor.blueColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
        self.attributedStringValue = NSAttributedString(string: self.stringValue, attributes: attributes)
    }

    override func mouseDown(event: NSEvent) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: self.href)!)
    }
}
