//
//  MIDIEvent.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class MIDINotificationCenter {
    
    
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
        
        switch type {
            
        case .noteOn:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MIDINotificationType.noteOn.rawValue), object: object)
            
        case .noteOff:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MIDINotificationType.noteOff.rawValue), object: object)
            
        case .control:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MIDINotificationType.control.rawValue), object: object)
            
        }
        
    }
    
    
    // subscribe to notifications
    static func observe(type: MIDINotificationType, observer: Any, selector: Selector) {
    
        switch type {
            
        case .noteOn:
            NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: MIDINotificationType.noteOn.rawValue), object: nil)
            
        case .noteOff:
            NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: MIDINotificationType.noteOff.rawValue), object: nil)
            
        case .control:
            NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: MIDINotificationType.control.rawValue), object: nil)
            
        }
    
    }
    
}
