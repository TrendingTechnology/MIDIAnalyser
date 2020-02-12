/*
  Constants to do with notes and intervals
*/

// midi numbers for keys        // A0
final int whiteKeyMIDInumbers[] = {21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40, 41, 
                                   43, 45, 47, 48, 50, 52, 53, 55, 57, 59, 60, 62, 64, 
                                   65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84, 86, 
                                   88, 89, 91, 93, 95, 96, 98, 100, 101, 103, 105, 107, 
                                   108, 110};

                                // A#0
final int blackKeyMIDInumbers[] = {22, 25, 27, 30, 32, 34, 37, 39, 42, 44, 46, 49, 51,
                                   54, 56, 58, 61, 63, 66, 68, 70, 73, 75, 78, 80, 82,
                                   85, 87, 90, 92, 94, 97, 99, 102, 104, 106};                               

// number of keys
final int nWhiteKeys = whiteKeyMIDInumbers.length;
final int nBlackKeys = blackKeyMIDInumbers.length;
final int nKeys = nWhiteKeys + nBlackKeys;

                        
final boolean isWhiteKey[] = {true, false, true, false, true, true, false, true, false, true, false, true, // C0 - B0
                              true, false, true, false, true, true, false, true, false, true, false, true, // C1 - B1
                              true, false, true, false, true, true, false, true, false, true, false, true, // C2 - B2
                              true, false, true, false, true, true, false, true, false, true, false, true, // C3 - B3
                              true, false, true, false, true, true, false, true, false, true, false, true, // C4 - B4
                              true, false, true, false, true, true, false, true, false, true, false, true, // C5 - B5
                              true, false, true, false, true, true, false, true, false, true, false, true, // C6 - B6
                              true, false, true, false, true, true, false, true, false, true, false, true, // C7 - B7
                              true, false, true, false, true, true, false, true, false, true, false, true};// C8 - B8
                              
// notes pressed
boolean keyStates[] = new boolean[nWhiteKeys + nBlackKeys];
boolean lastKeyStates[] = new boolean[nWhiteKeys + nBlackKeys];

// key display
pianoKey whiteKeys[] = new pianoKey[nWhiteKeys];
pianoKey keys[] = new pianoKey[nKeys];





// intervals in semitones
final int unison = 0;
final int min2   = 1;
final int maj2   = 2;
final int min3   = 3;
final int maj3   = 4;
final int perf4  = 5;
final int aug4   = 6;
final int dim5   = 6;
final int perf5  = 7;
final int min6   = 8;
final int maj6   = 9;
final int min7   = 10;
final int maj7   = 11;
final int perf8  = 12;

final String intervalNames[] = {"unison", "minor 2nd", "major 2nd", "minor 3rd", "major 3rd", "perfect 4th", 
                                "augmented 4th / diminished 5th", "perfect 5th", "minor 6th", "major 6th",
                                "minor 7th", "major 7th", "octave"};



// note name strings
final String noteNamesSharps[] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
final String noteNamesFlats[] = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"};


// MIDI values for notes
final int A0 = 21;
final int C4 = 60;  // middle C
final int C8 = 108;
