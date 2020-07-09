//
//  GrandStaffView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa
import Foundation


class GrandStaffView: NSView {
    
    // subviews
    private var bassStaff: StaffLineView = StaffLineView(frame: NSRect())
    private var trebleStaff: StaffLineView = StaffLineView(frame: NSRect())
    private var bassClefTextField: NSTextField = NSTextField()
    private var trebleClefTextField: NSTextField = NSTextField()
    
    // dimensions
    private var staffHeight: CGFloat = 0
    private var staffLineSpacing: CGFloat = 0
    private var highestTrebleLedgerLine: Int = 3 // note E6
    private var lowestTrebleLedgerLine: Int = 1 // note C4
    private var highestBassLedgerLine: Int = 1 // note C4
    private var lowestBassLedgerLine: Int = 3 // note A1
    
    private var musicalSymbolsFont: String = "Emmentaler-26"
    
    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        // clef characters
        self.bassClefTextField.stringValue = "\u{1D122}" // E1A7
        self.trebleClefTextField.stringValue = "\u{E1AA}" // 1D11E
        
        // text fields for clefs
        self.bassClefTextField.isEditable = false
        self.bassClefTextField.isSelectable = false
        self.bassClefTextField.isBordered = false
        self.bassClefTextField.drawsBackground = false
        self.bassClefTextField.textColor = .white
        self.bassClefTextField.canDrawSubviewsIntoLayer = true
        self.bassClefTextField.frame = NSRect()
        
        self.trebleClefTextField.isEditable = false
        self.trebleClefTextField.isSelectable = false
        self.trebleClefTextField.isBordered = false
        self.trebleClefTextField.drawsBackground = false
        self.trebleClefTextField.textColor = .white
        self.trebleClefTextField.canDrawSubviewsIntoLayer = true
        self.trebleClefTextField.frame = NSRect()
        
        // add subviews
        self.addSubview(bassStaff)
        self.addSubview(trebleStaff)
        self.addSubview(bassClefTextField)
        self.addSubview(trebleClefTextField)
        
        // observers
        NotificationCenter.default.addObserver(self, selector: #selector(drawNotes), name: NSNotification.Name(rawValue: ChordNotesMessage.ChordNotesMessageName), object: nil)
        
    }
    

    override func draw(_ dirtyRect: NSRect) {
        
        // superclass drawing
        super.draw(dirtyRect)
        
        // call the drawing functions
        drawStaffLines()
        drawVerticalLines()
        drawClefs()
        drawKeySignature(GrandStaffKeySignature.Dbmajor)
        
    }
    
    private func drawStaffLines() {

        let staffSize: NSSize = NSSize(width: self.frame.width, height: 46) // (h - 2) /4 must be whole number
                                                                            // 46
        
        let staffSpacing: CGFloat = 50
        let bassStaffOrigin: NSPoint = NSPoint(x: self.frame.origin.x,
                                               y: self.frame.origin.y + (self.frame.size.height - staffSpacing) / 2 - staffSize.height)
        let trebleStaffOrigin: NSPoint = NSPoint(x: bassStaffOrigin.x,
                                                 y: bassStaffOrigin.y + staffSize.height + staffSpacing)
        
        bassStaff.frame = NSRect(origin: bassStaffOrigin, size: staffSize)
        trebleStaff.frame = NSRect(origin: trebleStaffOrigin, size: staffSize)
        
        // calculate dimensions for use in this class
        bassStaff.calculateDimensions()
        trebleStaff.calculateDimensions()

    }
    
    
    private func drawClefs() {
        
        // draw the bass clef with some magic numbers
        bassClefTextField.font = NSFont(name: musicalSymbolsFont, size: bassStaff.lineSpacing * 4.6)
        bassClefTextField.frame.origin.x = self.frame.origin.x + bassStaff.lineSpacing / 2
        bassClefTextField.frame.origin.y = bassStaff.frame.origin.y - bassStaff.lineSpacing + bassStaff.lineSpacing * 0.2
        bassClefTextField.frame.size.height = bassStaff.lineSpacing * 8 // 4.4
        bassClefTextField.frame.size.width = bassStaff.lineSpacing * 4 // 4
        
        // draw the treble clef with some magic numbers
        trebleClefTextField.font = NSFont(name: musicalSymbolsFont, size: trebleStaff.lineSpacing * 4.5)
        trebleClefTextField.frame.origin.x = self.frame.origin.x + trebleStaff.lineSpacing / 2
        trebleClefTextField.frame.origin.y = trebleStaff.frame.origin.y - 2.95 * trebleStaff.lineSpacing
        trebleClefTextField.frame.size.height = trebleStaff.lineSpacing * 10 // 10
        trebleClefTextField.frame.size.width = trebleStaff.lineSpacing * 4 // 4

    }
    
    
    private func drawVerticalLines() {
        
        // fetch and setup graphics context
        guard let context = NSGraphicsContext.current?.cgContext else{
            fatalError("Missing NSGraphicsContext in GrandStaffView")
        }
        
        context.setStrokeColor(CGColor.white)
        
        let halfPixelOffset: CGFloat = 0.5
        
        // draw the left side line
        do {
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(4)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()

            
        }
        
        // draw the right side lines
        do {
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x + bassStaff.frame.size.width,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(6)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            
        }
        
        do {

            let offset: CGFloat = 8
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x + bassStaff.frame.size.width - offset,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            
        }
        
    }
    
    private func drawKeySignature(_ key: GrandStaffKeySignature) {
     
        // draw sharps on treble clef lines
        for accidental in key.accidentals {
            
            
            if key.isSharpsKey {
                drawAccidentalOnStaff(staff: trebleStaff,
                                      line: accidental.trebleStaffLineNumber,
                                      position: accidental.order,
                                      accidental: "\u{E10E}")
                drawAccidentalOnStaff(staff: bassStaff,
                                      line: accidental.trebleStaffLineNumber,
                                      position: accidental.order,
                                      accidental: "\u{E10E}")
                
                //drawSharpOnStaff(staff: trebleStaff, line: accidental.trebleStaffLineNumber, position: accidental.order)
                //drawSharpOnStaff(staff: bassStaff, line: accidental.bassStaffLineNumber, position: accidental.order)
            }
            else {
                drawAccidentalOnStaff(staff: trebleStaff,
                                      line: accidental.trebleStaffLineNumber,
                                      position: accidental.order,
                                      accidental: "\u{E11A}")
                drawAccidentalOnStaff(staff: bassStaff,
                                      line: accidental.trebleStaffLineNumber,
                                      position: accidental.order,
                                      accidental: "\u{E11A}")
            }
        }
        
    }
    
    private func drawAccidentalOnStaff(staff: StaffLineView, line: Float, position: Int, accidental: String) {
        
        // work out dimensions
        let accidental: NSTextField = NSTextField(string: accidental)
        let accidentalSize: CGSize = CGSize(width: 20, height: 100)
        let horizontalSpacing: CGFloat = 10
        
        // set up the view
        accidental.font = NSFont(name: musicalSymbolsFont, size: trebleStaff.lineSpacing * 3)
        accidental.textColor = .white
        accidental.isBordered = false
        accidental.isEditable = false
        accidental.drawsBackground = false
        accidental.frame = NSRect(origin: .zero, size: accidentalSize)
        accidental.frame.origin.x = staff.frame.origin.x + trebleClefTextField.frame.size.width + horizontalSpacing * CGFloat(position)
        accidental.frame.origin.y = staff.frame.origin.y - staff.lineSpacing * 5 + staff.lineSpacing * CGFloat(line)
        
        // draw the view
        self.addSubview(accidental) /// need better view management here, array of accidentals to be appended and deleted on redraw
        
    }
    
    @objc func drawNotes(_ notification: Notification) {
        
        // stem rules:
        // - stem length = 1 octave
        // - if the note furthest from the middle line is above the middle line, the stem of the chord points downwards.
        // - if the note furthest from the middle line is below the middle line, the stem of the chord points upwards.
        // - could just ignore stems
        
        // notehead position rules
        // - seconds to the right
        
        // deconstruct notification
        var notes: [Int] = Array()
        
        if let message = notification.object as? ChordNotesMessage {
            notes = message.notes
        }
        
        if notes.count != 0 {
        
            let note: GrandStaffNote = GrandStaffNote(MIDINumber: notes[0])
            
            drawNoteHead(staff: note.staffToDrawOn == GrandStaffNote.Staff.treble ? trebleStaff : bassStaff,
                         line: note.lineToDrawOn,
                         direction: .left,
                         requiresLedgerLine: note.requiresLedgerLine)
        }

        
    }
    
    private func drawNoteHead(staff: StaffLineView, line: Float, direction: GrandStaffNote.NoteHeadDirection, requiresLedgerLine: Bool) {
        
        // work out dimensions
        let noteHead: NSTextField = NSTextField(string: GrandStaffNote.noteHeadCode)
        let noteHeadSize: CGSize = CGSize(width: 20, height: 100)
        
        // set up the view
        noteHead.font = NSFont(name: musicalSymbolsFont, size: trebleStaff.lineSpacing * 3)
        noteHead.textColor = .white
        noteHead.isBordered = false
        noteHead.isEditable = false
        noteHead.drawsBackground = false
        noteHead.frame = NSRect(origin: .zero, size: noteHeadSize)
        noteHead.frame.origin.x = staff.frame.origin.x + staff.frame.size.width / 2
        noteHead.frame.origin.y = staff.frame.origin.y - staff.lineSpacing * 5 + staff.lineSpacing * CGFloat(line)
        
        // draw the view
        self.addSubview(noteHead)
        
        // ledger line
        if requiresLedgerLine {
            
            // fetch and setup graphics context
            guard let context = NSGraphicsContext.current?.cgContext else{
                fatalError("Missing NSGraphicsContext in GrandStaffView")
            }
            
            context.setStrokeColor(CGColor.white)
            
            let halfPixelOffset: CGFloat = 0.5
            
            do {
                
                let startPoint: CGPoint = CGPoint(x: noteHead.frame.origin.x,
                                                  y: staff.frame.origin.y + halfPixelOffset * 2 + staff.lineSpacing * CGFloat(line))
                let endPoint: CGPoint = CGPoint(x: startPoint.x + 15,
                                                y: startPoint.y)
                
                context.setLineWidth(2)
                context.beginPath()
                context.move(to: startPoint)
                context.addLine(to: endPoint)
                context.strokePath()

                
            }
        }
        
        
    }
    
    
    
}

