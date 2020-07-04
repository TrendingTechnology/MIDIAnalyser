//
//  AKPWMOscillator.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

/// Casio-style phase distortion with "pivot point" on the X axis This module is
/// designed to emulate the classic phase distortion synthesis technique. From
/// the mid 90's. The technique reads the first and second halves of the ftbl at
/// different rates in order to warp the waveform. For example, pdhalf can
/// smoothly transition a sinewave into something approximating a sawtooth wave.
///
open class AKPWMOscillator: AKNode, AKToggleable, AKComponent {
    public typealias AKAudioUnitType = AKPWMOscillatorAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(generator: "pwmo")

    // MARK: - Properties

    private var internalAU: AKAudioUnitType?
    private var token: AUParameterObserverToken?

    fileprivate var frequencyParameter: AUParameter?
    fileprivate var amplitudeParameter: AUParameter?
    fileprivate var pulseWidthParameter: AUParameter?
    fileprivate var detuningOffsetParameter: AUParameter?
    fileprivate var detuningMultiplierParameter: AUParameter?

    /// Lower and upper bounds for Frequency
    public static let frequencyRange = 0.0 ... 20000.0

    /// Lower and upper bounds for Amplitude
    public static let amplitudeRange = 0.0 ... 10.0

    /// Lower and upper bounds for Pulse Width
    public static let pulseWidthRange = 0.0 ... 1.0

    /// Lower and upper bounds for Detuning Offset
    public static let detuningOffsetRange = -1000.0 ... 1000.0

    /// Lower and upper bounds for Detuning Multiplier
    public static let detuningMultiplierRange = 0.9 ... 1.11

    /// Initial value for Frequency
    public static let defaultFrequency = 440.0

    /// Initial value for Amplitude
    public static let defaultAmplitude = 1.0

    /// Initial value for Pulse Width
    public static let defaultPulseWidth = 0.5

    /// Initial value for Detuning Offset
    public static let defaultDetuningOffset = 0.0

    /// Initial value for Detuning Multiplier
    public static let defaultDetuningMultiplier = 1.0

    /// Ramp Duration represents the speed at which parameters are allowed to change
    @objc open dynamic var rampDuration: Double = AKSettings.rampDuration {
        willSet {
            internalAU?.rampDuration = newValue
        }
    }

    /// Frequency in cycles per second
    @objc open dynamic var frequency: Double = defaultFrequency {
        willSet {
            if frequency == newValue {
                return
            }
            if internalAU?.isSetUp ?? false {
                if let existingToken = token {
                    frequencyParameter?.setValue(Float(newValue), originator: existingToken)
                    return
                }
            }
            internalAU?.setParameterImmediately(.frequency, value: newValue)
        }
    }

    /// Output Amplitude.
    @objc open dynamic var amplitude: Double = defaultAmplitude {
        willSet {
            if amplitude == newValue {
                return
            }
            if internalAU?.isSetUp ?? false {
                if let existingToken = token {
                    amplitudeParameter?.setValue(Float(newValue), originator: existingToken)
                    return
                }
            }
            internalAU?.setParameterImmediately(.amplitude, value: newValue)
        }
    }

    /// Duty Cycle Width 0 - 1
    @objc open dynamic var pulseWidth: Double = defaultPulseWidth {
        willSet {
            if pulseWidth == newValue {
                return
            }
            if internalAU?.isSetUp ?? false {
                if let existingToken = token {
                    pulseWidthParameter?.setValue(Float(newValue), originator: existingToken)
                    return
                }
            }
            internalAU?.setParameterImmediately(.pulseWidth, value: newValue)
        }
    }

    /// Frequency offset in Hz.
    @objc open dynamic var detuningOffset: Double = defaultDetuningOffset {
        willSet {
            if detuningOffset == newValue {
                return
            }
            if internalAU?.isSetUp ?? false {
                if let existingToken = token {
                    detuningOffsetParameter?.setValue(Float(newValue), originator: existingToken)
                    return
                }
            }
            internalAU?.setParameterImmediately(.detuningOffset, value: newValue)
        }
    }

    /// Frequency detuning multiplier
    @objc open dynamic var detuningMultiplier: Double = defaultDetuningMultiplier {
        willSet {
            if detuningMultiplier == newValue {
                return
            }
            if internalAU?.isSetUp ?? false {
                if let existingToken = token {
                    detuningMultiplierParameter?.setValue(Float(newValue), originator: existingToken)
                    return
                }
            }
            internalAU?.setParameterImmediately(.detuningMultiplier, value: newValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    @objc open dynamic var isStarted: Bool {
        return internalAU?.isPlaying ?? false
    }

    // MARK: - Initialization

    /// Initialize the oscillator with defaults
    public convenience override init() {
        self.init(frequency: 440)
    }

    /// Initialize this oscillator node
    ///
    /// - Parameters:
    ///   - frequency: In cycles per second, or Hz.
    ///   - amplitude: Output amplitude
    ///   - pulseWidth: Duty cycle width (range 0-1).
    ///   - detuningOffset: Frequency offset in Hz.
    ///   - detuningMultiplier: Frequency detuning multiplier
    ///
    @objc public init(
        frequency: Double,
        amplitude: Double = defaultAmplitude,
        pulseWidth: Double = defaultPulseWidth,
        detuningOffset: Double = defaultDetuningOffset,
        detuningMultiplier: Double = defaultDetuningMultiplier) {

        self.frequency = frequency
        self.amplitude = amplitude
        self.pulseWidth = pulseWidth
        self.detuningOffset = detuningOffset
        self.detuningMultiplier = detuningMultiplier

        _Self.register()

        super.init()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { [weak self] avAudioUnit in
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

        frequencyParameter = tree["frequency"]
        amplitudeParameter = tree["amplitude"]
        pulseWidthParameter = tree["pulseWidth"]
        detuningOffsetParameter = tree["detuningOffset"]
        detuningMultiplierParameter = tree["detuningMultiplier"]

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
        internalAU?.setParameterImmediately(.frequency, value: frequency)
        internalAU?.setParameterImmediately(.amplitude, value: amplitude)
        internalAU?.setParameterImmediately(.pulseWidth, value: pulseWidth)
        internalAU?.setParameterImmediately(.detuningOffset, value: detuningOffset)
        internalAU?.setParameterImmediately(.detuningMultiplier, value: detuningMultiplier)
    }

    /// Function to start, play, or activate the node, all do the same thing
    @objc open func start() {
        internalAU?.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    @objc open func stop() {
        internalAU?.stop()
    }
}
