//
//  AppDelegate.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 11/02/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    // terminate the application when red X pressed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
