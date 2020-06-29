//
//  AnalysePermutationOldVersions.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/04/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation

/*
  // analyse one chord from its intervals
  func analysePermutationOld(intervals: [Int], root: String) -> String {
      
      // define interval names in terms of semitones
      let minorSecond = 1
      let majorSecond = 2
      let minorThird = 3
      let majorThird = 4
      let perfectFourth = 5
      let flatFifth = 6
      let perfectFifth = 7
      let minorSixth = 8
      let majorSixth = 9
      let minorSeventh = 10
      let majorSeventh = 11
      
      
      // decide which intervals are in the chord
      var intervalStates: [Bool] = Array(repeating: false, count: 12)
      
      for i in 0...12 {
          if(intervals.contains(i)) {
              intervalStates[i] = true
          }
      }
      
      intervalStates[0] = false // ignore unison zero distance interval
      
      
      // first determine base tonality (major, minor, diminished, augmented, sus2, sus4)
      var baseTonality: String = ""
      
      if(intervalStates[perfectFifth]) {
          
          intervalStates[perfectFifth] = false
          
          if(intervalStates[majorThird]) {
              baseTonality = "M"
              intervalStates[majorThird] = false
          }
          else if(intervalStates[minorThird]) {
              baseTonality = "m"
              intervalStates[minorThird] = false
          }
          else if(intervalStates[majorSecond]) {
              baseTonality = "sus2"
              intervalStates[majorSecond] = false
          }
          else if(intervalStates[perfectFourth]) {
              baseTonality = "sus4"
              intervalStates[perfectFourth] = false
          }
          else {
              baseTonality = "5"
          }
      }
      else if(intervalStates[flatFifth] && intervalStates[minorThird]) {
          baseTonality = "dim"
          intervalStates[flatFifth] = false
          intervalStates[minorThird] = false
      }
      else if(intervalStates[minorSixth] && intervalStates[majorThird]) {
          baseTonality = "aug"
          intervalStates[minorSixth] = false
          intervalStates[majorThird] = false
      }
      else {
          
          // stuff with no 5
          if(intervalStates[majorThird]) {
              baseTonality = "M(no5)"
              intervalStates[majorThird] = false
          }
          else if(intervalStates[minorThird]) {
              baseTonality = "m(no5)"
              intervalStates[minorThird] = false
          }
          else if(intervalStates[majorSecond]) {
              baseTonality = "sus2(no5)"
              intervalStates[majorSecond] = false
          }
          else if(intervalStates[perfectFourth]) {
              baseTonality = "sus4(no5)"
              intervalStates[perfectFourth] = false
          }
          else {
              baseTonality = "[unknown]"
          }
          
      }

      
      // check for primary extensions
      var primaryExtension: String = ""
      
      if(intervalStates[majorSeventh]) {
          primaryExtension = "maj7"
          intervalStates[majorSeventh] = false
      }
      else if(intervalStates[minorSeventh]) {
          primaryExtension = "7"
          intervalStates[minorSeventh] = false
      }
      else if(intervalStates[majorSixth] && (baseTonality != "5")) {
          primaryExtension = "6"
          intervalStates[majorSixth] = false
      }
      else {
          primaryExtension = "[none]"
      }
      
      
      // handle some special cases
      if(baseTonality == "dim") {
          
          if(primaryExtension == "6") {
              primaryExtension = "7"     // dim7 chord
          }
          else if(primaryExtension == "7") {
              baseTonality = "m"
              primaryExtension = "7b5"    // m7b5 chord
          }

      }
      
      /*
      if(baseTonality == "aug") {
          if(primaryExtension == "7") {
              baseTonality = "M"
              primaryExtension = "7#5"    // weird aug chord
          }
      }*/
      
      // add extensions
      var extensions: String = ""
      
      if(intervalStates[minorSecond])    {extensions += "b9 ";    intervalStates[minorSecond] = false}
      if(intervalStates[majorSecond])    {extensions += "9 ";     intervalStates[majorSecond] = false}
      if(intervalStates[minorThird])     {extensions += "#9 ";    intervalStates[minorThird] = false}
      if(intervalStates[perfectFourth])  {extensions += "11 ";    intervalStates[perfectFourth] = false}
      if(intervalStates[flatFifth])      {extensions += "#11 ";   intervalStates[flatFifth] = false}
      if(intervalStates[minorSixth])     {extensions += "b13 ";   intervalStates[minorSixth] = false}
      if(intervalStates[majorSixth])     {extensions += "13 ";    intervalStates[majorSixth] = false}
      if(intervalStates[minorSeventh])     {extensions += "#13 ";    intervalStates[minorSeventh] = false}
      
      
      // handle special cases and format into name properly according to (very inconsistent) conventions
      var chordName: String = root
      
      if((baseTonality != "sus2") && (baseTonality != "sus4") && !baseTonality.contains("no5")) {
          chordName += baseTonality + primaryExtension
      }
      else if(baseTonality.contains("no5") && primaryExtension == "6"){
          chordName += baseTonality + primaryExtension
      }
      else {
          chordName += primaryExtension + baseTonality
      }
      
      chordName += "add(" + extensions + ")"
      
      chordName = chordName.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: ",)", with: ")", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "add", with: " add", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "sus", with: " sus", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "[none]", with: "", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "[unknown]", with: " [unknown] ", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "add()", with: "", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "M", with: "", options: .literal, range: nil)

      if(extensions.count < 3 && !extensions.contains("#") && !extensions.contains("b")) {
          chordName = chordName.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
          chordName = chordName.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
      }
      chordName = chordName.replacingOccurrences(of: "6 add9", with: "6/9", options: .literal, range: nil)
      
      chordName = chordName.replacingOccurrences(of: "no5", with: "(no5)", options: .literal, range: nil)
      chordName = chordName.replacingOccurrences(of: "((no5))", with: "(no5)", options: .literal, range: nil)
      
      // debug print
      /*print("")
      print("Interval set: ", "\(intervals)")
      print("Interval states: ", "\(intervalStates)" )
      print("Root: " + root)
      print("Base tonality: " + baseTonality)
      print("Primary extension: " + primaryExtension)
      print("Extensions: " + extensions)
      print("")*/
      
      return chordName
  }
*/
