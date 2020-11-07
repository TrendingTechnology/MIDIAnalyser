//
//  PreferencesNotificationCenter.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 06/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation

class PreferencesNotificationCenter {
    
    // post a notification
    static func post(type: Preferences.PreferenceKeys) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: nil)
        
    }
    
    // subscribe to notifications
    static func observe(type: Preferences.PreferenceKeys, observer: Any, selector: Selector) {
    
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    
    }
    
    
}
