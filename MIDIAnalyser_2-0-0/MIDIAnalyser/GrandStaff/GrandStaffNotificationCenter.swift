//
//  GrandStaffNotificationCenter.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 15/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation

class GrandStaffNotificationCenter {
    
    enum GrandStaffNotificationType: String {
        case keySignature = "keySignature"
    }
    
    // post a notification
    static func post(type: GrandStaffNotificationCenter.GrandStaffNotificationType, object: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: object)
        
    }
    
    
    // subscribe to notifications
    static func observe(type: GrandStaffNotificationCenter.GrandStaffNotificationType, observer: Any, selector: Selector) {
    
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    
    }
    
    
}
