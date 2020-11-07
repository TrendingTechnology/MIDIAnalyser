//
//  Preferences.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import Cocoa

class Preferences {
    
    enum PreferenceKeys: String {
        case InputDevice = "InputDevice"
        case MIDITypingEnabled = "MIDITypingEnabled"
        case SustainReleaseClearsChordName = "SustainReleaseClearsChordName"
        case SustainPedalAffectsKeyboardView = "SustainPedalAffectsKeyboardView"
        case ChordNameFormat = "ChordNameFormat"
        case TreatSlashRootsAsExtensions = "TreatSlashRootsAsExtensions"
        case AbbreviateIgnoreNo5 = "AbbreviateIgnoreNo5"
        case AbbreviateIgnoreNo3 = "AbbreviateIgnoreNo3"
        case AbbreviateHideSlashRoots = "AbbreviateHideSlashRoots"
        case SingleNoteInputDisplayed = "SingleNoteInputDisplayed"
        case IntervalInputDisplayed = "IntervalInputDisplayed"
        case Appearance = "Appearance"
        case AppearanceName = "AppearanceName"
        case PressedKeyColor = "PressedKeyColor"
    }
    
    static func save(key: PreferenceKeys, data: Any) {
        
        // store the data
        UserDefaults.standard.set(data, forKey: key.rawValue)
        
        // post a notification
        PreferencesNotificationCenter.post(type: key)
        
    }
    
    static func load(key: PreferenceKeys) -> Any? {
            return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
}


