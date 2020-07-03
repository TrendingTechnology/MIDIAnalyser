//
//  AKSampler.swift
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

/// Sampler
///
@objc open class AKSampler: AKPolyphonicNode, AKComponent {
    public typealias AKAudioUnitType = AKSamplerAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(instrument: "AKss")

    // MARK: - Properties

    @objc public var internalAU: AKAudioUnitType?
    private var token: AUParameterObserverToken?

    fileprivate var masterVolumeParameter: AUParameter?
    fileprivate var pitchBendParameter: AUParameter?
    fileprivate var vibratoDepthParameter: AUParameter?
    fileprivate var filterCutoffParameter: AUParameter?
    fileprivate var filterStrengthParameter: AUParameter?
    fileprivate var filterResonanceParameter: AUParameter?
    fileprivate var glideRateParameter: AUParameter?

    fileprivate var attackDurationParameter: AUParameter?
    fileprivate var decayDurationParameter: AUParameter?
    fileprivate var sustainLevelParameter: AUParameter?
    fileprivate var releaseDurationParameter: AUParameter?

    fileprivate var filterAttackDurationParameter: AUParameter?
    fileprivate var filterDecayDurationParameter: AUParameter?
    fileprivate var filterSustainLevelParameter: AUParameter?
    fileprivate var filterReleaseDurationParameter: AUParameter?

    fileprivate var filterEnableParameter: AUParameter?
    fileprivate var loopThruReleaseParameter: AUParameter?
    fileprivate var monophonicParameter: AUParameter?
    fileprivate var legatoParameter: AUParameter?
    fileprivate var keyTrackingParameter: AUParameter?
    fileprivate var filterEnvelopeVelocityScalingParameter: AUParameter?

    /// Ramp Duration represents the speed at which parameters are allowed to change
    @objc open dynamic var rampDuration: Double = AKSettings.rampDuration {
        willSet {
            internalAU?.rampDuration = newValue
        }
    }

    /// Master volume (fraction)
    @objc open dynamic var masterVolume: Double = 1.0 {
        willSet {
            if masterVolume == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && masterVolumeParameter != nil {
                    masterVolumeParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.masterVolume = newValue
        }
    }

    /// Pitch offset (semitones)
    @objc open dynamic var pitchBend: Double = 0.0 {
        willSet {
            if pitchBend == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && pitchBendParameter != nil {
                    pitchBendParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.pitchBend = newValue
        }
    }

    /// Vibrato amount (semitones)
    @objc open dynamic var vibratoDepth: Double = 1.0 {
        willSet {
            if vibratoDepth == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && vibratoDepthParameter != nil {
                    vibratoDepthParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.vibratoDepth = newValue
        }
    }

    /// Filter cutoff (harmonic ratio)
    @objc open dynamic var filterCutoff: Double = 4.0 {
        willSet {
            if filterCutoff == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && filterCutoffParameter != nil {
                    filterCutoffParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.filterCutoff = newValue
        }
    }

    /// Filter EG strength (harmonic ratio)
    @objc open dynamic var filterStrength: Double = 20.0 {
        willSet {
            if filterStrength == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && filterStrengthParameter != nil {
                    filterStrengthParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.filterStrength = newValue
        }
    }

    /// Filter resonance (dB)
    @objc open dynamic var filterResonance: Double = 0.0 {
        willSet {
            if filterResonance == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && filterResonanceParameter != nil {
                    filterResonanceParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.filterResonance = newValue
        }
    }

    /// Glide rate (seconds per octave)
    @objc open dynamic var glideRate: Double = 0.0 {
        willSet {
            if glideRate == newValue {
                return
            }

            if internalAU?.isSetUp ?? false {
                if token != nil && glideRateParameter != nil {
                    glideRateParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.glideRate = newValue
        }
    }

    /// Amplitude attack duration (seconds)
    @objc open dynamic var attackDuration: Double = 0.0 {
        willSet {
            if attackDuration != newValue {
                internalAU?.attackDuration = newValue
            }
        }
    }

    /// Amplitude Decay duration (seconds)
    @objc open dynamic var decayDuration: Double = 0.0 {
        willSet {
            if decayDuration != newValue {
                internalAU?.decayDuration = newValue
            }
        }
    }

    /// Amplitude sustain level (fraction)
    @objc open dynamic var sustainLevel: Double = 1.0 {
        willSet {
            if sustainLevel != newValue {
                internalAU?.sustainLevel = newValue
            }
        }
    }

    /// Amplitude Release duration (seconds)
    @objc open dynamic var releaseDuration: Double = 0.0 {
        willSet {
            if releaseDuration != newValue {
                internalAU?.releaseDuration = newValue
            }
        }
    }

    /// Filter attack duration (seconds)
    @objc open dynamic var filterAttackDuration: Double = 0.0 {
        willSet {
            if filterAttackDuration != newValue {
                internalAU?.filterAttackDuration = newValue
            }
        }
    }

    /// Filter Decay duration (seconds)
    @objc open dynamic var filterDecayDuration: Double = 0.0 {
        willSet {
            if filterDecayDuration != newValue {
                internalAU?.filterDecayDuration = newValue
            }
        }
    }

    /// Filter sustain level (fraction)
    @objc open dynamic var filterSustainLevel: Double = 1.0 {
        willSet {
            if filterSustainLevel != newValue {
                internalAU?.filterSustainLevel = newValue
            }
        }
    }

    /// Filter Release duration (seconds)
    @objc open dynamic var filterReleaseDuration: Double = 0.0 {
        willSet {
            if filterReleaseDuration != newValue {
                internalAU?.filterReleaseDuration = newValue
            }
        }
    }

    /// Filter Enable (boolean, 0.0 for false or 1.0 for true)
    @objc open dynamic var filterEnable: Bool = false {
        willSet {
            if filterEnable != newValue {
                internalAU?.filterEnable = newValue ? 1.0 : 0.0
            }
        }
    }

    /// Loop Thru Release (boolean, 0.0 for false or 1.0 for true)
    @objc open dynamic var loopThruRelease: Bool = false {
        willSet {
            if loopThruRelease != newValue {
                internalAU?.loopThruRelease = newValue ? 1.0 : 0.0
            }
        }
    }

    /// isMonophonic (boolean, 0.0 for false or 1.0 for true)
    @objc open dynamic var isMonophonic: Bool = false {
        willSet {
            if isMonophonic != newValue {
                internalAU?.isMonophonic = newValue ? 1.0 : 0.0
            }
        }
    }

    /// isLegato (boolean, 0.0 for false or 1.0 for true)
    @objc open dynamic var isLegato: Bool = false {
        willSet {
            if isLegato != newValue {
                internalAU?.isLegato = newValue ? 1.0 : 0.0
            }
        }
    }

    /// keyTrackingFraction (-2.0 to +2.0, normal range 0.0 to 1.0)
    @objc open dynamic var keyTrackingFraction: Double = 1.0 {
        willSet {
            if keyTrackingFraction != newValue {
                internalAU?.keyTrackingFraction = newValue
            }
        }
    }

    /// filterEnvelopeVelocityScaling (fraction 0.0 to 1.0)
    @objc open dynamic var filterEnvelopeVelocityScaling: Double = 0.0 {
        willSet {
            if filterEnvelopeVelocityScaling != newValue {
                internalAU?.filterEnvelopeVelocityScaling = newValue
            }
        }
    }

    // MARK: - Initialization

    /// Initialize this sampler node
    ///
    /// - Parameters:
    ///   - masterVolume: 0.0 - 1.0
    ///   - pitchBend: semitones, signed
    ///   - vibratoDepth: semitones, typically less than 1.0
    ///   - filterCutoff: relative to sample playback pitch, 1.0 = fundamental, 2.0 = 2nd harmonic etc
    ///   - filterStrength: same units as filterCutoff; amount filter EG adds to filterCutoff
    ///   - filterResonance: dB, -20.0 - 20.0
    ///   - attackDuration: seconds, 0.0 - 10.0
    ///   - decayDuration: seconds, 0.0 - 10.0
    ///   - sustainLevel: 0.0 - 1.0
    ///   - releaseDuration: seconds, 0.0 - 10.0
    ///   - filterEnable: true to enable per-voice filters
    ///   - filterAttackDuration: seconds, 0.0 - 10.0
    ///   - filterDecayDuration: seconds, 0.0 - 10.0
    ///   - filterSustainLevel: 0.0 - 1.0
    ///   - filterReleaseDuration: seconds, 0.0 - 10.0
    ///   - glideRate: seconds/octave, 0.0 - 10.0
    ///   - loopThruRelease: if true, sample will continue looping after key release
    ///   - isMonophonic: true for mono, false for polyphonic
    ///   - isLegato: (mono mode onl) if true, legato notes will not retrigger
    ///   - keyTracking: -2.0 - 2.0, 1.0 means perfect key tracking, 0.0 means none
    ///   - filterEnvelopeVelocityScaling: fraction, 0.0 - 1.0
    ///
    @objc public init(
        masterVolume: Double = 1.0,
        pitchBend: Double = 0.0,
        vibratoDepth: Double = 0.0,
        filterCutoff: Double = 4.0,
        filterStrength: Double = 20.0,
        filterResonance: Double = 0.0,
        attackDuration: Double = 0.0,
        decayDuration: Double = 0.0,
        sustainLevel: Double = 1.0,
        releaseDuration: Double = 0.0,
        filterEnable: Bool = false,
        filterAttackDuration: Double = 0.0,
        filterDecayDuration: Double = 0.0,
        filterSustainLevel: Double = 1.0,
        filterReleaseDuration: Double = 0.0,
        glideRate: Double = 0.0,
        loopThruRelease: Bool = true,
        isMonophonic: Bool = false,
        isLegato: Bool = false,
        keyTracking: Double = 1.0,
        filterEnvelopeVelocityScaling: Double = 0.0) {

        self.masterVolume = masterVolume
        self.pitchBend = pitchBend
        self.vibratoDepth = vibratoDepth
        self.filterCutoff = filterCutoff
        self.filterStrength = filterStrength
        self.filterResonance = filterResonance
        self.attackDuration = attackDuration
        self.decayDuration = decayDuration
        self.sustainLevel = sustainLevel
        self.releaseDuration = releaseDuration
        self.filterEnable = filterEnable
        self.filterAttackDuration = filterAttackDuration
        self.filterDecayDuration = filterDecayDuration
        self.filterSustainLevel = filterSustainLevel
        self.filterReleaseDuration = filterReleaseDuration
        self.glideRate = glideRate
        self.loopThruRelease = loopThruRelease
        self.isMonophonic = isMonophonic
        self.isLegato = isLegato
        self.keyTrackingFraction = keyTracking
        self.filterEnvelopeVelocityScaling = filterEnvelopeVelocityScaling

        AKSampler.register()

        super.init()

        AVAudioUnit._instantiate(with: AKSampler.ComponentDescription) { [weak self] avAudioUnit in
            guard let strongSelf = self else {
                AKLog("Error: self is nil")
                return
            }
            strongSelf.avAudioUnit = avAudioUnit
            strongSelf.avAudioNode = avAudioUnit
            strongSelf.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
        }

        guard let tree = internalAU?.parameterTree else {
            AKLog("Parameter Tree Failed")
            return
        }

        self.masterVolumeParameter = tree["masterVolume"]
        self.pitchBendParameter = tree["pitchBend"]
        self.vibratoDepthParameter = tree["vibratoDepth"]
        self.filterCutoffParameter = tree["filterCutoff"]
        self.filterStrengthParameter = tree["filterStrength"]
        self.filterResonanceParameter = tree["filterResonance"]
        self.attackDurationParameter = tree["attackDuration"]
        self.decayDurationParameter = tree["decayDuration"]
        self.sustainLevelParameter = tree["sustainLevel"]
        self.releaseDurationParameter = tree["releaseDuration"]
        self.filterAttackDurationParameter = tree["filterAttackDuration"]
        self.filterDecayDurationParameter = tree["filterDecayDuration"]
        self.filterSustainLevelParameter = tree["filterSustainLevel"]
        self.filterReleaseDurationParameter = tree["filterReleaseDuration"]
        self.filterEnableParameter = tree["filterEnable"]
        self.glideRateParameter = tree["glideRate"]
        self.loopThruReleaseParameter = tree["loopThruRelease"]
        self.monophonicParameter = tree["monophonic"]
        self.legatoParameter = tree["legato"]
        self.keyTrackingParameter = tree["keyTracking"]
        self.filterEnvelopeVelocityScalingParameter = tree["filterEnvelopeVelocityScaling"]

        token = tree.token(byAddingParameterObserver: { [weak self] _, _ in

            guard let _ = self else {
                AKLog("Unable to create strong reference to self")
                return
            } // Replace _ with strongSelf if needed
            DispatchQueue.main.async {
                // This node does not change its own values so we won't add any
                // value observing, but if you need to, this is where that goes.
            }
        })

        self.internalAU?.setParameterImmediately(.masterVolume, value: masterVolume)
        self.internalAU?.setParameterImmediately(.pitchBend, value: pitchBend)
        self.internalAU?.setParameterImmediately(.vibratoDepth, value: vibratoDepth)
        self.internalAU?.setParameterImmediately(.filterCutoff, value: filterCutoff)
        self.internalAU?.setParameterImmediately(.filterStrength, value: filterStrength)
        self.internalAU?.setParameterImmediately(.filterResonance, value: filterResonance)
        self.internalAU?.setParameterImmediately(.attackDuration, value: attackDuration)
        self.internalAU?.setParameterImmediately(.decayDuration, value: decayDuration)
        self.internalAU?.setParameterImmediately(.sustainLevel, value: sustainLevel)
        self.internalAU?.setParameterImmediately(.releaseDuration, value: releaseDuration)
        self.internalAU?.setParameterImmediately(.filterAttackDuration, value: filterAttackDuration)
        self.internalAU?.setParameterImmediately(.filterDecayDuration, value: filterDecayDuration)
        self.internalAU?.setParameterImmediately(.filterSustainLevel, value: filterSustainLevel)
        self.internalAU?.setParameterImmediately(.filterReleaseDuration, value: filterReleaseDuration)
        self.internalAU?.setParameterImmediately(.filterEnable, value: filterEnable ? 1.0 : 0.0)
        self.internalAU?.setParameterImmediately(.glideRate, value: glideRate)
        self.internalAU?.setParameterImmediately(.loopThruRelease, value: loopThruRelease ? 1.0 : 0.0)
        self.internalAU?.setParameterImmediately(.monophonic, value: isMonophonic ? 1.0 : 0.0)
        self.internalAU?.setParameterImmediately(.legato, value: isLegato ? 1.0 : 0.0)
        self.internalAU?.setParameterImmediately(.keyTrackingFraction, value: keyTracking)
        self.internalAU?.setParameterImmediately(.filterEnvelopeVelocityScaling, value: filterEnvelopeVelocityScaling)
    }

    @objc open func loadAKAudioFile(from sampleDescriptor: AKSampleDescriptor, file: AKAudioFile) {
        let sampleRate = Float(file.sampleRate)
        let sampleCount = Int32(file.samplesCount)
        let channelCount = Int32(file.channelCount)
        let flattened = Array(file.floatChannelData!.joined())
        let data = UnsafeMutablePointer<Float>(mutating: flattened)
        internalAU?.loadSampleData(from: AKSampleDataDescriptor(sampleDescriptor: sampleDescriptor,
                                                                sampleRate: sampleRate,
                                                                isInterleaved: false,
                                                                channelCount: channelCount,
                                                                sampleCount: sampleCount,
                                                                data: data) )
    }

    @objc open func stopAllVoices() {
        internalAU?.stopAllVoices()
    }

    @objc open func restartVoices() {
        internalAU?.restartVoices()
    }

    @objc open func loadRawSampleData(from sampleDataDescriptor: AKSampleDataDescriptor) {
        internalAU?.loadSampleData(from: sampleDataDescriptor)
    }

    @objc open func loadCompressedSampleFile(from sampleFileDescriptor: AKSampleFileDescriptor) {
        internalAU?.loadCompressedSampleFile(from: sampleFileDescriptor)
    }

    @objc open func unloadAllSamples() {
        internalAU?.unloadAllSamples()
    }

    @objc open func setNoteFrequency(noteNumber: MIDINoteNumber, frequency: Double) {
        internalAU?.setNoteFrequency(noteNumber: Int32(noteNumber), noteFrequency: Float(frequency))
    }

    @objc open func buildSimpleKeyMap() {
        internalAU?.buildSimpleKeyMap()
    }

    @objc open func buildKeyMap() {
        internalAU?.buildKeyMap()
    }

    @objc open func setLoop(thruRelease: Bool) {
        internalAU?.setLoop(thruRelease: thruRelease)
    }

    @objc open override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, frequency: Double) {
        internalAU?.playNote(noteNumber: noteNumber, velocity: velocity, noteFrequency: Float(frequency))
    }

    @objc open override func stop(noteNumber: MIDINoteNumber) {
        internalAU?.stopNote(noteNumber: noteNumber, immediate: false)
    }

    @objc open func silence(noteNumber: MIDINoteNumber) {
        internalAU?.stopNote(noteNumber: noteNumber, immediate: true)
    }

    @objc open func sustainPedal(pedalDown: Bool) {
        internalAU?.sustainPedal(down: pedalDown)
    }
}
