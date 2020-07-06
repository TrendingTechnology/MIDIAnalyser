//
//  PreferencesTabViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class PreferencesTabViewController: NSTabViewController {
    
    private lazy var tabViewSizes: [String : NSSize] = [:]


    override func viewDidLoad() {
        
        // add size of first tab to tabViewSizes
        if let viewController = self.tabViewItems.first?.viewController, let title = viewController.title {
            tabViewSizes[title] = viewController.view.frame.size
        }
        
        // superclass view loaded
        super.viewDidLoad()

    }
    
    
    override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions, completionHandler completion: (() -> Void)?) {

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            self.updateWindowFrameAnimated(viewController: toViewController)
            super.transition(from: fromViewController, to: toViewController, options: [.crossfade, .allowUserInteraction], completionHandler: completion)
        }, completionHandler: nil)
    }

    func updateWindowFrameAnimated(viewController: NSViewController) {

        guard let title = viewController.title, let window = view.window else {
            return
        }

        let contentSize: NSSize

        if tabViewSizes.keys.contains(title) {
            contentSize = tabViewSizes[title]!
        }
        else {
            contentSize = viewController.view.frame.size
            tabViewSizes[title] = contentSize
        }

        let newWindowSize = window.frameRect(forContentRect: NSRect(origin: NSPoint.zero, size: contentSize)).size

        var frame = window.frame
        frame.origin.y += frame.height
        frame.origin.y -= newWindowSize.height
        frame.size = newWindowSize
        window.animator().setFrame(frame, display: false)
    }

}

// see: https://stackoverflow.com/questions/27578085/resizing-window-to-view-controller-size-in-storyboard/29345086
