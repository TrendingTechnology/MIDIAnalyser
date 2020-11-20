//
//  MIDIEvent.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class MIDINotificationCenter {
    
    // possible types of MIDI events
    enum MIDINotificationType: String {
        case noteOn = "noteOn"
        case noteOff = "noteOff"
        case control = "control"
    }
    
    // initialisation
    init() {
        
    }
    
    // post a notification
    static func post(type: MIDINotificationType, object: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: object)
    }
    
    // subscribe to notifications
    static func observe(type: MIDINotificationType, observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    }
    
}
